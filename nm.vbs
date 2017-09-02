option explicit
dim source, out, i
if wscript.arguments.count < 1 then
    wscript.quit(1)
end if
source = wscript.arguments.item(0)
out = ""
for i = 1 to len(source)
    dim mi
    mi = mid(source, i, 1)
    if mi >= "0" and mi <= "9" then
        out = out + mi
    end if
next
wscript.echo "nm_" + out
