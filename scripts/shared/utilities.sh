#!/usr/bin/env bash

# Path: scripts/shared/utilities.sh

utilities::command_exists() {
  local -r command="$1"
  command -v "${command}" >/dev/null 2>&1
}

utilities::has_value() {
  local -r text="$1"
  [[ -n ${text} ]]
}

utilities::is_empty_or_null() {
  local -r text="$1"
  [[ -z ${text:-} ]]
}

utilities::count_tags() {
  git tag | wc -l
}

utilities::repository_has_any_tags() {
  local -i total_tags
  if ! total_tags=$(utilities::count_tags); then
    echo "Could not count tags"
    exit 1
  fi
  [[ ${total_tags} -ne 0 ]]
}

utilities::is_valid_semantic_version_string() {
  local version="$1"
  local -i -r MAX_LENGTH=256 # for package.json compatibility: https://github.com/npm/node-semver/blob/master/internal/constants.js
  if ((${#version} > MAX_LENGTH)); then
    echo "Version \"${version}\" is too long (max: ${MAX_LENGTH}, but was: ${#version})"
    return 1
  fi
  if [[ ! ${version} =~ ^[v]?[0-9]+\.[0-9]+\.[0-9]+ ]]; then
    echo "Version \"${version}\" is invalid (not in \`(v?)major.minor.patch\` format)"
    return 1
  fi
  return 0
}
# shellcheck disable=SC2001
# Take the version string and explode it into named parts and return a json object
utilities::json_version() {
  local -r version="$1"
  jq -n \
    --arg version "${version}" \
    '$version|capture("^(?<prefix>v)?(?<major>[0-9]+)([.](?<minor>[0-9]+))?([.](?<patch>[0-9]+))?(?<suffix>.*)$","n") |
    {major: (try (.major|tonumber) catch 0), minor: (try (.minor|tonumber) catch 0), patch: (try (.patch|tonumber) catch 0), prefix: (.prefix//""), suffix: (.suffix//"")} |
    {  "full":$version,
        "normal": "\(.major).\(.minor).\(.patch)",
        "major":.major,
        "major_minor":"\(.major).\(.minor)",
        "minor":.minor,
        "patch":.patch,
        "major_next":"\(.major+1).0.0",
        "major_next_stub":"\(.major+1)",
        "minor_next": "\(.major).\(.minor+1).0",
        "minor_next_stub": "\(.major).\(.minor+1)",
        "patch_next":"\(.major).\(.minor).\(.patch+1)",
        "suffix":.suffix,
        "prefix":.prefix
      }'
}

utilities::git_remote_tags() {
  git ls-remote --tags "$@"
}
# Prints a list of all tags, sorted by version
utilities::print_all_tags_version_sorted() {
  utilities::git_remote_tags | grep -E '^v?([0-9]+)\.([0-9]+)\.([0-9]+)' | sort -V
}

# Prints a list of all tags, sorted by date
utilities::print_all_tags_date_sorted() {
  utilities::git_remote_tags --sort=taggerdate | grep -E '^v?([0-9]+)\.([0-9]+)\.([0-9]+)'
}

# Prints latest version, exists with positive code if it cannot
utilities::print_latest_version() {
  if ! utilities::repository_has_any_tags; then
    exit 1
  fi
  local -r sort_by="${1:-version}"
  if [[ ${sort_by} == version ]]; then
    local -r latest_tag=$(utilities::print_all_tags_version_sorted | tail -1)
  elif [[ ${sort_by} == date ]]; then
    local -r latest_tag=$(utilities::print_all_tags_date_sorted | tail -1)
  fi
  if ! utilities::is_valid_semantic_version_string "${latest_tag}"; then
    exit 1
  fi
  echo "${latest_tag}"
}

utilities::has_single_version() {
  local -i total_tags
  if ! total_tags=$(utilities::count_tags); then
    echo "Could not count tags"
    exit 1
  fi
  if [[ ${total_tags} -eq "1" ]]; then
    return 0 # There is only a a single tag
  fi
  return 1 # There are none or multiple tags
}

# Prints latest version, exists with positive code if it cannot
utilities::print_previous_version() {
  local -i total_tags
  if ! total_tags=$(utilities::count_tags); then
    echo "Could not count tags"
    exit 1
  fi
  if [[ ${total_tags} -le 1 ]]; then
    echo "There's only a single version"
    exit 1
  fi
  local -r sort_by="${1:-version}"
  if [[ ${sort_by} == version ]]; then
    local -r previous_tag=$(utilities::print_all_tags_version_sorted | tail -2 | head -1)
  elif [[ ${sort_by} == date ]]; then
    local -r previous_tag=$(utilities::print_all_tags_date_sorted | tail -2 | head -1)
  fi
  if ! utilities::is_valid_semantic_version_string "${previous_tag}"; then
    exit 1
  fi
  echo "${previous_tag}"
}

utilities::file_exists() {
  local -r file=$1
  [[ -f ${file} ]]
}

utilities::equals_case_insensitive() {
  [[ ${1,,} == "${2,,}" ]]
}
