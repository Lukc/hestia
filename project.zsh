
package=(hestia)
version="0.5.0"

variables=(
	LUA_VERSION 5.1
	LUA_SHAREDIR '$(SHAREDIR)/lua/$(LUA_VERSION)'
)

targets=(hestia.moon)
type[hestia.moon]="script"
filename[hestia.moon]="hestia"

for file in hestia/**/*.moon; do
	if [[ "$file" =~ ^examples/.* ]]; then
		continue
	fi

	targets+=($file)
	type[$file]=moon
	install[$file]="\$(LUA_SHAREDIR)/$(dirname ${file#modules/})"
	auto[$file]=true
done

dist=(
	hestia.moon
	**/*.moon
	# build.zsh
	project.zsh Makefile
	# Documentation
	hestia.cfg
	**/*.md
)

