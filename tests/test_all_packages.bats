#!/usr/bin/env bats

cd $BATS_TEST_DIRNAME

distro="alpine"
if grep -iq "ubuntu" /etc/issue; then
  distro="ubuntu"
fi
SKIP_FILE=packages_${distro}_skip.txt
DOCKER_FILE=./containers/${distro}.Dockerfile

expected_version() {
  grep -Eo "( |#)${1}(|-cli)(|@\"|~)=[^\`\"; *-]+" $DOCKER_FILE | tr "=" "\n" | tr ":" "\n" | tail -1
}

@test "test each package individually and verify version" {
  packages_count=0
  final_status=0
  for package in $(bash packages_all.sh); do
    if [ -n $package ] && ! grep -q "^$package$" $SKIP_FILE; then
      run expected_version $package
      [ "$status" -eq 0 ]
      [ -n "$output" ]

      package="$package" expected_ver="$output" run bats -t test_package.bats
      echo "# $output" >&3
      echo "#" >&3
      packages_count=$(($packages_count + 1))
      final_status=$(($final_status + $status))
    fi
  done

  echo "# tested ${packages_count} commands individually" >&3
  echo "#" >&3

  echo "# status code=$final_status" >&3
  [ "$final_status" -eq 0 ]
  echo "#" >&3
}

@test "test all packages at once" {
  # subtract skips from full list
  packages_to_skip="$(grep -Ev "^\s*(#|$)" $SKIP_FILE | xargs | tr " " "|")"
  packages=$(bash packages_all.sh | egrep -Ev "^($packages_to_skip)$" | xargs)

  run ../has $packages
  echo "$output" >&3
  echo "#" >&3

  packages_count=$(echo "${packages}" | wc -w)
  echo "# tested ${packages_count} commands simultaneously" >&3
  actual_packages_count=$(echo "${output}" | wc -l)
  echo "# received output from ${actual_packages_count} commands" >&3
  [ "$packages_count" -eq "$actual_packages_count" ]
  echo "#" >&3

  echo "# status code=$status" >&3
  [ "$status" -eq 0 ]
  echo "#" >&3
}
