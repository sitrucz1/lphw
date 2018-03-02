'
' Slide puzzle heuristic cost objects
'

option explicit

class tcosthamming

    public function getcost(byval board)
        dim i, cost : cost = 0
        for i = 0 to ubound(board.m_board)
            dim tile : tile = board.m_board(i)
            if tile > 0 and tile <> i+1 then
                cost = cost+1
            end if
        next
        getcost = cost
    end function

end class

class tcostmanhattan

    private m_degree
    private m_walk

    public function init(byval degree)
        if degree < 2 or degree > 5 then
            m_degree = 3
        else
            m_degree = degree
        end if
        m_walk = makewalk(degree)
        set init = me
    end function

    public function getcost(byval board)
        dim i, cost : cost = 0
        for i = 0 to m_degree*m_degree-1
            cost = cost + m_walk(board.m_board(i), i)
        next
        getcost = cost
    end function

    private function makewalk(degree)
        dim i, j, arr()
        redim arr(degree*degree-1, degree*degree-1)
        for i = 0 to degree*degree-1
            for j = 1 to degree*degree
                if i = 0 then
                    arr(i, j-1) = 0
                else
                    arr(i, j-1) = abs(getrow(i-1) - getrow(j-1)) + abs(getcol(i-1) - getcol(j-1))
                end if
            next
        next
        makewalk = arr
    end function

    private function getrow(byval n)
        getrow = n \ m_degree
    end function

    private function getcol(byval n)
        getcol = n mod m_degree
    end function

    private function lpad(byval istr, byval length, byval padchar)
        lpad = right(string(length, padchar) & istr, length)
    end function

    public sub printwalk
        dim i, j
        for i = 0 to m_degree*m_degree-1
            for j = 0 to m_degree*m_degree-1
                wscript.stdout.write lpad(m_walk(i, j), 3, " ")
            next
            wscript.stdout.writeline
        next
    end sub

end class
