'
' A slide puzzle solver
'
option explicit

includefile "slideglobals.vbs"   ' global constants
includefile "slideboard.vbs"     ' tboard

sub main()
    ' dim solver : set solver = new tslidesolver.init(4)
    dim board : set board = (new tboard).init(9, vbnull, mvnull)
    ' board.printwalk
    board.shuffle
    board.printboard
    wscript.echo board.m_cost
    wscript.stdout.writeline board.issolvable
    wscript.stdout.writeline board.issolved
end sub

sub includefile(fspec)
    executeglobal createobject("scripting.filesystemobject").opentextfile(fspec).readall()
end sub

class tslidesolver

    public function init(byval degree)
        set init = me
    end function

end class

call main
