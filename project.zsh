
package=(lunadoc)
version="0.5.0"

variables=(
	LUA_VERSION 5.1
	LUA_SHAREDIR '$(SHAREDIR)/lua/$(LUA_VERSION)'
)

targets=(lunadoc)
type[lunadoc]="script"
sources[lunadoc]=""

for file in modules/**/*.moon; do
	if [[ "$file" =~ ^examples/.* ]]; then
		continue
	fi

	targets+=($file)
	type[$file]=moon
	install[$file]="\$(LUA_SHAREDIR)/$(dirname ${file#modules/})"
	auto[$file]=true
done

dist=(
	lunadoc
	**/*.moon
	# build.zsh
	project.zsh Makefile
	# Documentation
	lunadoc.cfg
	**/*.md
	# Luarocks
	package/*.rockspec
)

