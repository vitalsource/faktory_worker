## 1.9.3 - 2022-12-02

###Fixes

- Add ability to test code that contains faktory batches by returning default values for these rather than crashing/timing out

## [1.9.2] - 2022-10-31

### Fixes

- Fixes issue where ports that timed our of were closed upstream were not closed in faktory_worker ([#172](https://github.com/opt-elixir/faktory_worker/pull/172))

### Updates

- Bump jason from 1.3.0 to 1.4.0 ([#170](https://github.com/opt-elixir/faktory_worker/pull/170))
- Bump ex_doc from 0.28.4 to 0.28.5 ([#169](https://github.com/opt-elixir/faktory_worker/pull/169))
## [1.9.1] - 2022-08-24

- Add more granular warn/error level logging for various events in telemetry ([#166](https://github.com/opt-elixir/faktory_worker/pull/166))

## [1.9.0] - 2022-05-11

- `FaktoryWorker.send_command/2` added to make one-off commands more ergonomic
- support added for `TRACK GET` and `TRACK SET` commands

## [1.8.1] - 2022-04-04

- Push timeouts will no longer `raise` by default (instead of raising, they will
  now return `{:error, :timeout}`).

## [1.8.0] - 2022-04-04
- Fix `parent_id` vs `parent_bid`
This was a typo making passing of children batches require using `parent_id` over `parent_bid` which the docs say
- Bump some deps with dependabot (`telemetry` 1.0.0 to 1.1.0, `ex_doc` from `0.28` to `0.28.3`

## [1.7.0] - 2022-02-09
### Removed

- Removed Broadway to simplify supervision tree [#149](https://github.com/opt-elixir/faktory_worker/pull/149)

## Updates

- Updated exDoc [#151](https://github.com/opt-elixir/faktory_worker/pull/151)

## [1.6.0] - 2021-11-05


### Added

- Enterprise batching support in [#139](https://github.com/opt-elixir/faktory_worker/pull/139)

### Changed

- Bump excoveralls from 0.14.1 to 0.14.4 [#140](https://github.com/opt-elixir/faktory_worker/pull/140)
- Bump ex_doc from 0.24.2 to 0.25.5 [#141](https://github.com/opt-elixir/faktory_worker/pull/141)
- Bump mox from 1.0.0 to 1.0.1 [#142](https://github.com/opt-elixir/faktory_worker/pull/142)
- Bump broadway from 1.0.0 to 1.0.1 [#143](https://github.com/opt-elixir/faktory_worker/pull/143)
