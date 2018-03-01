'
' A slide puzzle solver
'
option explicit

includefile "slideglobals.vbs"   ' global constants
includefile "slideboard.vbs"     ' tboard

sub main()
    ' dim solver : set solver = new tslidesolver.init(4)
    dim board : set board = (new tboard).init(4)
    dim b2 : set b2 = board.clone
    board.printboard
    b2.move(mvleft)
    b2.move(mvleft)
    b2.move(mvup)
    b2.move(mvup)
    wscript.echo board.tostring
    wscript.echo b2.tostring
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
            ' m_walk = array()
            ' redim m_walk(m_degree*m_degree-1, m_degree*m_degree-1)
            ' dim j
            ' for i = 0 to m_degree*m_degree-1
            '     for j = 1 to m_degree*m_degree
            '         if i = 0 then
            '             m_walk(i, j-1) = 0
            '         else
            '             m_walk(i, j-1) = abs(getrow(i-1) - getrow(j-1)) + abs(getcol(i-1) - getcol(j-1))
            '         end if
            '     next
            ' next
