# Change Log

## v0.6.0

- Add `SatisfyRule` as `satisfy`
- Add `RespondToRule` as `respond_to`

## v0.5.0

### New features

- Add validation mechanism for parameters of rule
- Validate parameters of each builtin rule in `Validator#initialize`

### Bug fixes

- Add `eq` to builtin rules map

## v0.4.0

- Add `AnyRule` as `any`
- Add transaction API to collector for commit/rollback errors

## v0.3.0

- Add `EqRule` as `eq`
- Enable `TypeRule` to check boolean (`true` or `false`)

## v0.2.0

- Change signature of rule's `#validate` to enable nested schema
- Include rule name in error message
- Add `EachRule` as `each_rule`
- Add `EachKeyRule` as `each_key_rule`
- Add `EachValueRule` as `each_value_rule`
- Add `KeyValueRule` as `key_value_rule`

## v0.1.0

First release
