# Rubocop

## ファイル単位でrubocopをON/OFF
```
# rubocop:disable Metrics/LineLength, Style/StringLiterals
[...]
# rubocop:enable Metrics/LineLength, Style/StringLiterals
```

```
# rubocop:disable all
[...]
# rubocop:enable all
```

```
for x in (0..19) # rubocop:disable Style/AvoidFor
```
