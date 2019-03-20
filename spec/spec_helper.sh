#shellcheck shell=sh

set -eu

shellspec_mockable shellspec_unixtime
shellspec_mockable shellspec_output
shellspec_mockable shellspec_output_failure_message
shellspec_mockable shellspec_output_failure_message_when_negated
shellspec_mockable shellspec_on
shellspec_mockable shellspec_off
shellspec_mockable shellspec_is
shellspec_mockable shellspec_syntax_dispatch
shellspec_mockable shellspec_callback

shellspec_spec_helper_configure() {
  shellspec_import 'support/custom_matcher'

  set_subject() {
    shellspec_capture SHELLSPEC_SUBJECT subject
  }

  set_status() {
    shellspec_capture SHELLSPEC_STATUS status
  }

  set_stdout() {
    shellspec_capture SHELLSPEC_STDOUT stdout
  }

  set_stderr() {
    shellspec_capture SHELLSPEC_STDERR stderr
  }

  # modifier for test
  shellspec_syntax shellspec_modifier__modifier_
  shellspec_modifier__modifier_() {
    [ "${SHELLSPEC_SUBJECT+x}" ] || return 1
    shellspec_puts "$SHELLSPEC_SUBJECT"
  }

  intercept_shellspec_subject() {
    shellspec_around_invoke() {
      shellspec_output() { shellspec_puts "$1" >&2; }
      "$@"
    }
  }

  intercept_shellspec_modifier() {
    shellspec_around_invoke() {
      shellspec_output() { shellspec_puts "$1" >&2; }
      "$@"
    }
  }

  intercept_shellspec_matcher() {
    shellspec_around_invoke() {
      shellspec_output() { shellspec_puts "$1" >&2; }
      shellspec_is() { shellspec_puts "is:$*"; }
      shellspec_proxy "shellspec_matcher_do_match" \
                      "shellspec_matcher_do_match_positive"
      "$@"
      shellspec_if MATCHED
    }
  }

  shellspec_syntax_alias 'shellspec_subject_switch' 'shellspec_subject_value'
  switch_on() { shellspec_if "$SHELLSPEC_SUBJECT"; }
  switch_off() { shellspec_unless "$SHELLSPEC_SUBJECT"; }

  # shellcheck disable=SC2034
  LF="$SHELLSPEC_LF" TAB="$SHELLSPEC_TAB"
}
