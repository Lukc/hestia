(sep, plain)=>
    @=tostring @
    start = 1
    done = false
    pass=(i, j, ...)->
      if i
        seg = @\sub(start, i - 1)
        start = j + 1
        return seg, ...
      else
        done = true
        return @\sub(start)
    return ->
      return if done
      if sep == ''
        done = true
        return @
      return pass @\find sep, start, plain
