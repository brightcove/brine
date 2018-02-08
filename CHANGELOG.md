# Change Log

## [v0.6.0](https://github.com/brightcove/brine/tree/v0.6.0) (2018-02-08)
[Full Changelog](https://github.com/brightcove/brine/compare/v0.5.0...v0.6.0)

**Closed issues:**

- Assertion for empty values [\#99](https://github.com/brightcove/brine/issues/99)

**Merged pull requests:**

- Expose Faraday middleware extensibility [\#102](https://github.com/brightcove/brine/pull/102) ([mwhipple](https://github.com/mwhipple))
-  Add is\_empty assertion \(Fix \#99\) [\#100](https://github.com/brightcove/brine/pull/100) ([mwhipple](https://github.com/mwhipple))

## [v0.5.0](https://github.com/brightcove/brine/tree/v0.5.0) (2017-12-05)
[Full Changelog](https://github.com/brightcove/brine/compare/0.5.0...v0.5.0)

**Closed issues:**

- Publish first Gem [\#83](https://github.com/brightcove/brine/issues/83)

**Merged pull requests:**

- Add travis config; rename gem \(Fix \#83\) [\#94](https://github.com/brightcove/brine/pull/94) ([mwhipple](https://github.com/mwhipple))

## [0.5.0](https://github.com/brightcove/brine/tree/0.5.0) (2017-12-05)
[Full Changelog](https://github.com/brightcove/brine/compare/0.4.0...0.5.0)

**Fixed bugs:**

- Pin cucumber version [\#85](https://github.com/brightcove/brine/issues/85)

**Closed issues:**

- Assess custom testing "store" vs. Faraday doubles [\#89](https://github.com/brightcove/brine/issues/89)
- Integer type matching [\#82](https://github.com/brightcove/brine/issues/82)
- Publish/Open Source [\#78](https://github.com/brightcove/brine/issues/78)
- GitHub access for Brightcove [\#76](https://github.com/brightcove/brine/issues/76)
- RFC: Object Traversal Syntax [\#62](https://github.com/brightcove/brine/issues/62)
- make cleanup delete retries more intentional [\#31](https://github.com/brightcove/brine/issues/31)

**Merged pull requests:**

- Pin cucumber version \(Fix \#85\) [\#93](https://github.com/brightcove/brine/pull/93) ([mwhipple](https://github.com/mwhipple))
-  Slightly less optimistic cleanup calls \(Fix \#31\) [\#92](https://github.com/brightcove/brine/pull/92) ([mwhipple](https://github.com/mwhipple))
- tests: Replace `store` with Faraday doubles [\#90](https://github.com/brightcove/brine/pull/90) ([mwhipple](https://github.com/mwhipple))
- Add type checking for Integers \(Fix \#82\) [\#88](https://github.com/brightcove/brine/pull/88) ([mwhipple](https://github.com/mwhipple))
- Support specifying request header values [\#80](https://github.com/brightcove/brine/pull/80) ([mwhipple](https://github.com/mwhipple))
- Add LICENSE [\#79](https://github.com/brightcove/brine/pull/79) ([mwhipple](https://github.com/mwhipple))
- Update docs; Cleanup [\#74](https://github.com/brightcove/brine/pull/74) ([mwhipple](https://github.com/mwhipple))

## [0.4.0](https://github.com/brightcove/brine/tree/0.4.0) (2017-09-20)
[Full Changelog](https://github.com/brightcove/brine/compare/0.3.3...0.4.0)

**Closed issues:**

- RFC: New Documentation solution [\#70](https://github.com/brightcove/brine/issues/70)
- Replace docs [\#68](https://github.com/brightcove/brine/issues/68)
- Enforce ruby version [\#38](https://github.com/brightcove/brine/issues/38)
- Type tests [\#63](https://github.com/brightcove/brine/issues/63)

**Merged pull requests:**

- Support request query parameters [\#72](https://github.com/brightcove/brine/pull/72) ([mwhipple](https://github.com/mwhipple))
- Initial User Guide \(Fixes \#70, \#68\) [\#71](https://github.com/brightcove/brine/pull/71) ([mwhipple](https://github.com/mwhipple))

## [0.3.3](https://github.com/brightcove/brine/tree/0.3.3) (2017-09-19)
[Full Changelog](https://github.com/brightcove/brine/compare/0.3.2...0.3.3)

**Closed issues:**

- RFC: Switch back to jsonpath [\#59](https://github.com/brightcove/brine/issues/59)

**Merged pull requests:**

- JSONPath for Traversal \(POC for \#62\) [\#65](https://github.com/brightcove/brine/pull/65) ([mwhipple](https://github.com/mwhipple))
- Add assertions for JSON types \(Fix \#63\) [\#64](https://github.com/brightcove/brine/pull/64) ([mwhipple](https://github.com/mwhipple))

## [0.3.2](https://github.com/brightcove/brine/tree/0.3.2) (2017-08-10)
[Full Changelog](https://github.com/brightcove/brine/compare/0.3.1...0.3.2)

**Merged pull requests:**

- adding options and head request methods [\#61](https://github.com/brightcove/brine/pull/61) ([tnc5484](https://github.com/tnc5484))

## [0.3.1](https://github.com/brightcove/brine/tree/0.3.1) (2017-08-03)
[Full Changelog](https://github.com/brightcove/brine/compare/0.3.0...0.3.1)

**Closed issues:**

- improve HTTP logging [\#49](https://github.com/brightcove/brine/issues/49)

**Merged pull requests:**

- Log HTTP bodies with DEBUG \(Fix \#49\) [\#55](https://github.com/brightcove/brine/pull/55) ([mwhipple](https://github.com/mwhipple))

## [0.3.0](https://github.com/brightcove/brine/tree/0.3.0) (2017-07-28)
[Full Changelog](https://github.com/brightcove/brine/compare/0.2.0...0.3.0)

**Implemented enhancements:**

- Define step for binding a timestamp [\#14](https://github.com/brightcove/brine/issues/14)

**Fixed bugs:**

- Deprecation code is not requoting values, leading to undefined steps. [\#39](https://github.com/brightcove/brine/issues/39)

**Closed issues:**

- RFC: Temple expansions everywhere [\#19](https://github.com/brightcove/brine/issues/19)
- Selectors for list membership [\#37](https://github.com/brightcove/brine/issues/37)
- replace jsonpath with object traversal [\#5](https://github.com/brightcove/brine/issues/5)
- support regex in including [\#3](https://github.com/brightcove/brine/issues/3)

**Merged pull requests:**

- Add all selector [\#53](https://github.com/brightcove/brine/pull/53) ([mwhipple](https://github.com/mwhipple))
- Improved path traversal and any selector \(Fix \#37\) [\#52](https://github.com/brightcove/brine/pull/52) ([mwhipple](https://github.com/mwhipple))
- Support for regexp and is\_matching assertion \(Fix \#3\) [\#51](https://github.com/brightcove/brine/pull/51) ([mwhipple](https://github.com/mwhipple))

## [0.2.0](https://github.com/brightcove/brine/tree/0.2.0) (2017-06-29)
[Full Changelog](https://github.com/brightcove/brine/compare/0.1.0...0.2.0)

**Closed issues:**

- Support calling multiple services [\#28](https://github.com/brightcove/brine/issues/28)

**Merged pull requests:**

- Support multiple clients [\#47](https://github.com/brightcove/brine/pull/47) ([mwhipple](https://github.com/mwhipple))

## [0.1.0](https://github.com/brightcove/brine/tree/0.1.0) (2017-06-26)
**Fixed bugs:**

- replaced\_with fights with step transformation [\#30](https://github.com/brightcove/brine/issues/30)
- Whitespace transform can overflow the stack [\#23](https://github.com/brightcove/brine/issues/23)

**Closed issues:**

- RFC: Subject selection in assertions [\#26](https://github.com/brightcove/brine/issues/26)
- Define deprecation policy [\#25](https://github.com/brightcove/brine/issues/25)
- Add Guard to Rake [\#20](https://github.com/brightcove/brine/issues/20)
- RFC: Flipped data comparison [\#18](https://github.com/brightcove/brine/issues/18)
- RFC: Prefer JSON deserialization over tables [\#17](https://github.com/brightcove/brine/issues/17)
- construction of deeper request values. [\#16](https://github.com/brightcove/brine/issues/16)
- README [\#11](https://github.com/brightcove/brine/issues/11)
- parallelized execution [\#9](https://github.com/brightcove/brine/issues/9)
- add support for randomization [\#8](https://github.com/brightcove/brine/issues/8)
- tests [\#7](https://github.com/brightcove/brine/issues/7)
- replace oauth2 with faraday middleware [\#6](https://github.com/brightcove/brine/issues/6)
- merge child with non child body matchers [\#4](https://github.com/brightcove/brine/issues/4)
- register cleanup hook [\#2](https://github.com/brightcove/brine/issues/2)

**Merged pull requests:**

- Some fixes [\#44](https://github.com/brightcove/brine/pull/44) ([mwhipple](https://github.com/mwhipple))
- Minor patches [\#41](https://github.com/brightcove/brine/pull/41) ([mwhipple](https://github.com/mwhipple))
- Add multiline child selector [\#40](https://github.com/brightcove/brine/pull/40) ([mwhipple](https://github.com/mwhipple))
- Switch DateTime to Time for more flexibility [\#36](https://github.com/brightcove/brine/pull/36) ([mwhipple](https://github.com/mwhipple))
- `include` assertion; multiline structure transforms [\#35](https://github.com/brightcove/brine/pull/35) ([mwhipple](https://github.com/mwhipple))
- \[WIP\] Support for dates; deprecation; selector and assertion split [\#29](https://github.com/brightcove/brine/pull/29) ([mwhipple](https://github.com/mwhipple))
- Adjust regex for multiline string; bind response directly [\#24](https://github.com/brightcove/brine/pull/24) ([mwhipple](https://github.com/mwhipple))
- initial request construction extraction and clearing of state [\#22](https://github.com/brightcove/brine/pull/22) ([mwhipple](https://github.com/mwhipple))
- Add Guard \(Fix \#20\) [\#21](https://github.com/brightcove/brine/pull/21) ([mwhipple](https://github.com/mwhipple))
- Add README [\#12](https://github.com/brightcove/brine/pull/12) ([mwhipple](https://github.com/mwhipple))
- Initial extraction; Fix \#6 [\#1](https://github.com/brightcove/brine/pull/1) ([mwhipple](https://github.com/mwhipple))



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*