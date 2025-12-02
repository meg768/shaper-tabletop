git-commit:
	git add .
	git commit -m "$(or $(m),Auto-commit: $(shell date))"
	git push

goto-github:
	open "https://github.com/meg768/shaper-tabletop"

