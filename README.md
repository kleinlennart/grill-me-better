# grill-me-better

A personalized fork of Matt Pocock's [`grilling` / `grill-me`](https://github.com/mattpocock/skills/tree/main/skills/productivity) skill: an agent interviews you relentlessly, in rounds, until a plan or design is fully thought through.

## Install

Into the current project:

```sh
npx skills add kleinlennart/grill-me-better -a claude-code
```

Add `-g` to install it globally (for all projects). Then invoke it with `/grill-me-better`, or just ask to be grilled.

## Layout

| Path                        | What it is                                                                                                                                            |
| --------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| `skills/grill-me-better/`   | The personalized skill. Edit this.                                                                                                                    |
| `upstream/`                 | Untouched snapshot of the upstream skills, pinned at the commit in `upstream/COMMIT`. Don't edit it. It's the baseline for spotting upstream changes. |
| `scripts/check-upstream.sh` | Diffs the snapshot against the latest upstream.                                                                                                       |

## Pulling in upstream changes

```sh
scripts/check-upstream.sh            # anything new upstream?
scripts/check-upstream.sh --update   # refresh upstream/ to the latest commit
git diff upstream/                   # review, then port what you want by hand
```

## License

MIT. Based on [mattpocock/skills](https://github.com/mattpocock/skills), © Matt Pocock; see [`LICENSE`](LICENSE).
