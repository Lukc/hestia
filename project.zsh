
package=(lunradoc)
version="0.5.0"

variables=(
	LUA_VERSION 5.1
	LUA_SHAREDIR '$(SHAREDIR)/lua/$(LUA_VERSION)'
)

targets=(lunradoc.moon)
type[lunradoc.moon]="script"
filename[lunradoc.moon]="lunradoc"

for file in lunradoc/**/*.moon; do
	if [[ "$file" =~ ^examples/.* ]]; then
		continue
	fi

	targets+=($file)
	type[$file]=moon
	install[$file]="\$(LUA_SHAREDIR)/$(dirname ${file#modules/})"
	auto[$file]=true
done

dist=(
	lunradoc.moon
	**/*.moon
	# build.zsh
	project.zsh Makefile
	# Documentation
	lunradoc.cfg
	**/*.md
)

