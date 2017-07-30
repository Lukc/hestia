#!/bin/zsh

export LUNADOC_PATH="$(dirname $(readlink -f $0))"
export LUNADOC_REAL_ROOT="$LUNADOC_PATH/.root"
export LUNADOC_SRC="$LUNADOC_PATH/.src"
export LUNADOC_ROOT="/tmp/.lunadoc.$(uuidgen -t)-$(uuidgen -r)"

continue_stage=n
if [ -f "$LUNADOC_PATH/.continue_stage" ]
  then continue_stage=$(cat "$LUNADOC_PATH/.continue_stage")
fi

if [ -f "$LUNADOC_PATH/.continue_root" ]
  then LUNADOC_ROOT=$(cat "$LUNADOC_PATH/.continue_root")
fi

case $continue_stage in
  n)
    rm -f "$LUNADOC_PATH/.continue_stage"
    rm -rf "$LUNADOC_ROOT" "$LUNADOC_SRC" "$LUNADOC_REAL_ROOT"
    mkdir -p "$LUNADOC_REAL_ROOT" "$LUNADOC_SRC"
    ln -s "$LUNADOC_REAL_ROOT" "$LUNADOC_ROOT"
    echo "$LUNADOC_ROOT" > "$LUNADOC_PATH/.continue_root"
    ;&
  luajit) v=8271c643c21d1b2f344e339f559f2de6f3663191
    echo "luajit" > "$LUNADOC_PATH/.continue_stage"
    cd $LUNADOC_SRC
    git clone http://luajit.org/git/luajit-2.0.git luajit || exit
    cd luajit
    git checkout ${v}
    make amalg PREFIX=$LUNADOC_ROOT CPATH=$LUNADOC_ROOT/include LIBRARY_PATH=$LUNADOC_ROOT/lib CFLAGS='-DLUAJIT_ENABLE_LUA52COMPAT -DLUAJIT_ENABLE_GC64' && \
    make install PREFIX=$LUNADOC_ROOT || exit
    ln -sf $(find $LUNADOC_ROOT/bin/ -name "luajit-2.1*" | head -n 1) $LUNADOC_ROOT/bin/luajit
    ;&
  luarocks) v=d2718bf39dace0af009b9484fc6019b276906023
    echo "luarocks" > "$LUNADOC_PATH/.continue_stage"
    cd $LUNADOC_SRC
    git clone https://github.com/luarocks/luarocks.git || exit
    cd luarocks
    git checkout ${v}
    git pull
    ./configure --prefix=$LUNADOC_ROOT \
                --lua-version=5.1 \
                --lua-suffix=jit \
                --with-lua=$LUNADOC_ROOT \
                --with-lua-include=$LUNADOC_ROOT/include/luajit-2.1 \
                --with-lua-lib=$LUNADOC_ROOT/lib/lua/5.1 \
                --force-config && \
    make build && make install || exit
    ;&
  moonscript)
    echo "moonscript" > "$LUNADOC_PATH/.continue_stage"
    $LUNADOC_ROOT/bin/luarocks install moonscript || exit
    ;&
  discount)
    echo "discount" > "$LUNADOC_PATH/.continue_stage"
    $LUNADOC_ROOT/bin/luarocks install discount || exit
    ;&
  etlua)
    echo "etlua" > "$LUNADOC_PATH/.continue_stage"
    $LUNADOC_ROOT/bin/luarocks install etlua || exit
    ;&
  loadkit)
    echo "loadkit" > "$LUNADOC_PATH/.continue_stage"
    $LUNADOC_ROOT/bin/luarocks install loadkit || exit
    ;&
  luafilesystem)
    echo "luafilesystem" > "$LUNADOC_PATH/.continue_stage"
    $LUNADOC_ROOT/bin/luarocks install luafilesystem || exit
    ;&
  wrappers)
    echo "wrappers" > "$LUNADOC_PATH/.continue_stage"
    # wrappers
    cat > $LUNADOC_PATH/.run <<END
#!/bin/zsh
export LUNADOC_PATH="\$(dirname "\$(readlink -f "\$0")")"
export LUNADOC_REAL_ROOT="\$LUNADOC_PATH/.root"
export LUNADOC_ROOT="$LUNADOC_ROOT"

[ -e "\$LUNADOC_ROOT" ] || ln -s "\$LUNADOC_PATH/.root" \$LUNADOC_ROOT

export PATH="\$LUNADOC_ROOT/bin:\$LUNADOC_ROOT/nginx/sbin:\$PATH"
export LD_LIBRARY_PATH="\$LUNADOC_ROOT/lib:\$LD_LIBRARY_PATH"

path_prefixes=(./custom_ \$LUNADOC_PATH/modules/ \$LUNADOC_ROOT/lualib/ \$LUNADOC_ROOT/share/luajit-2.1.0-beta3/ \$LUNADOC_ROOT/share/lua/5.1/)

LUA_PATH=""
LUA_CPATH=""
MOON_PATH=""

for prefix (\$path_prefixes)
  do LUA_PATH="\$LUA_PATH;\${prefix}?.lua;\${prefix}?/init.lua"
  LUA_CPATH="\$LUA_CPATH;\${prefix}?.so;"
  MOON_PATH="\$MOON_PATH;\${prefix}?.moon;\${prefix}?/init.moon"
done

export LUA_PATH
export LUA_CPATH
export MOON_PATH

fn=\$(basename \$0)
if [ "\$fn" = ".run" ]
  then exec "\$@"
else
  exec \$fn "\$@"
fi
END
    chmod a+rx $LUNADOC_PATH/.run
    ;&
  moonc_all)
    echo "moonc_all" > "$LUNADOC_PATH/.continue_stage"
    $LUNADOC_PATH/.run moonc $LUNADOC_PATH || exit
    ;&
#  doc)
#    echo "doc" > "$LUNADOC_PATH/.continue_stage"
#    cd $LUNADOC_PATH
#    $LUNADOC_PATH/.run ldoc -d doc -f markdown -t lunadoc . || exit
#    ;&
esac

# cleanup
rm -rf "$LUNADOC_SRC"
rm -f "$LUNADOC_ROOT" "$LUNADOC_PATH/.continue_stage" "$LUNADOC_PATH/.continue_root"
