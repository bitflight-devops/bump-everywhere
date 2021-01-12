#!/usr/bin/env bash

# Same logic as from docker-entrypoint.sh but script.sh is called instead of bump-everywhere.sh

main() {
    parameters=()
    for part in "$@"
    do
        if is_parameter_name_and_value_in_same_arg "$part"; then # Called by GitHub actions
            name=${part%% *}    # Before first whitespace
            value=${part#* }    # After first whitespace
            parameters+=("$name" "$value")
        else # Not by GitHub actions, send the parameters as they are
            parameters+=("$part")
        fi
    done
    echo "[docker-entrypoint.sh] Parameters:" "${parameters[@]}"
    local -r current_directory=$(dirname "$0")
    bash "$current_directory"/script.sh "${parameters[@]}"
}

is_parameter_name_and_value_in_same_arg() {
    local -r value="$1"
    if  starts_with "$value" '--'  && \
        includes "$value" ' '; then
        return 0
    else
        return 1
    fi
}

starts_with() {
    local -r value="$1"
    local -r prefix="$2"
    [[ $value = $prefix* ]]
}

includes() {
    local -r value="$1"
    local -r pattern="$2"
    [[ $value =~ $pattern ]]
}

main "$@"
