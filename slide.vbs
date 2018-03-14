'
' A slide puzzle solver
'
option explicit

includefile "slideglobals.vbs"   ' global constants
includefile "slideboard.vbs"     ' tboard
includefile "slidecost.vbs"      ' board heuristics

sub main()
    ' dim solver : set solver = new tslidesolver.init(4)
    dim board : set board = (new tboard).init(3)
    dim cost : set cost = (new tcostmanhattan).init(board.m_degree)
    board.shuffle
    board.printboard
    randomize
    dim cnt : cnt = 0
    dim prev : prev = mvnull
    do until board.issolved
        dim min : min = 99
        dim minbd : set minbd = nothing
        dim i, j
        j = int(mvcnt * rnd)
        for i = 0 to mvcnt-1
            if board.movevalid(j) and j <> prev then
                dim mv : set mv = board.clone
                mv.move(j)
                dim mvcost : mvcost = cost.getcost(mv) + cnt + 1
                if mvcost < min then
                    set minbd = mv
                    min = mvcost
                    prev = j
                end if
            end if
            j = (j+1) mod mvcnt
        next
        cnt = cnt+1
        set board = minbd
        board.printboard
    loop
end sub

sub includefile(fspec)
    executeglobal createobject("scripting.filesystemobject").opentextfile(fspec).readall()
end sub

class tslidesolver

    public function init(byval degree)
        set init = me
    end function

end class

class tslidestate

    public m_cost
    public m_moves
    public m_board

    public function init (byval cost, byval moves, byval board)
        m_cost = cost
        set m_moves = moves
        set m_board = board
    end function

    public function clone
        dim x : set x = new tslidestate
        x.m_cost = m_cost
        set x.m_moves = m_moves
        set x.m_board = m_board
        set clone = x
    end function

end class

call main
