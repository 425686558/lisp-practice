add:
	git add `git status -s|awk '{print $$2}'`
