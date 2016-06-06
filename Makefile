add:
	git add `git status -s|awk '{print $$2}'`
	git status -s
