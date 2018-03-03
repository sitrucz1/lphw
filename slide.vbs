'
' A slide puzzle solver
'
option explicit

includefile "slideglobals.vbs"   ' global constants
includefile "slideboard.vbs"     ' tboard
includefile "slidecost.vbs"      ' board heuristics

sub main()
    ' dim solver : set solver = new tslidesolver.init(4)
    dim board : set board = (new tboard).init(4)
    dim b2 : set b2 = board.clone
    board.printboard
    b2.move(mvleft)
    b2.move(mvleft)
    b2.move(mvup)
    b2.move(mvup)
    b2.printboard
    wscript.echo board.tostring
    wscript.echo b2.tostring
    dim cost : set cost = (new tcostmanhattan).init(board.m_degree)
    ' cost.printwalk
    wscript.echo cost.getcost(b2)
    dim cost2 : set cost2 = new tcosthamming
    wscript.echo cost2.getcost(b2)
    ' board.printwalk
    ' board.shuffle
    ' board.printboard
    ' wscript.echo board.m_cost
    ' wscript.stdout.writeline board.issolvable
    ' wscript.stdout.writeline board.issolved
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
