# github-real-stars

Count your GitHub stars, excluding the ones you gave yourself.

## Usage

```bash
# Your own repos
./real-stars.sh

# Someone else's repos
./real-stars.sh <username>
```

## Requirements

- [GitHub CLI (`gh`)](https://cli.github.com/) — authenticated
- Python 3

## Example Output

```
Repository                               Total    Real
----------                               -----    ----
live-dashboard                           4        3
NetKitX                                  2        1
fastlol                                  1        1

Total: 7 | Real (excluding self): 5
```
