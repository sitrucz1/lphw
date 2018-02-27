'
' A slide puzzle solver
'
option explicit

sub main()
    ' includefile "queue.vbs"     ' tqueue and tstack
    dim solver : set solver = new tslidesolver.init(4)
end sub

sub includefile(fspec)
    executeglobal createobject("scripting.filesystemobject").opentextfile(fspec).readall()
end sub

class tslidesolver

    public m_degree
    public m_board
    public m_walk

    public function init(byval degree)
        m_degree = degree
        m_board = array()
        redim m_board(m_degree*m_degree-1)
        dim i
        for i = 0 to m_degree*m_degree-2
            m_board(i) = i+1
        next
        m_board(m_degree*m_degree-1) = 0
        m_board(0) = 2 : m_board(1) = 1
        printboard
        m_walk = array()
        redim m_walk(m_degree*m_degree-1, m_degree*m_degree-1)
        dim j
        for i = 0 to m_degree*m_degree-1
            for j = 1 to m_degree*m_degree
                if i = 0 then
                    m_walk(i, j-1) = 0
                else
                    m_walk(i, j-1) = abs(row(i) - row(j)) + abs(col(i) - col(j))
                end if
            next
        next
        printwalk
        wscript.stdout.writeline getboardcost(m_board)
        wscript.stdout.writeline issolvable
        wscript.stdout.writeline issolved
        set init = me
    end function

    private function row(byval n)
        row = (n-1) \ m_degree
    end function

    private function col(byval n)
        col = (n-1) mod m_degree
    end function

    public function issolved
        dim i : i = m_degree*m_degree-1
        if m_board(i) <> 0 then
            issolved = false
            exit function
        end if
        for i = i-1 to 0 step -1
            if m_board(i) <> i+1 then
                issolved = false
                exit function
            end if
        next
        issolved = true
    end function

    public function issolvable
        dim i, j, cnt : cnt = 0
        for i = 0 to m_degree*m_degree-1
            for j = i+1 to m_degree*m_degree-1
                if m_board(j) > 0 and m_board(j) < m_board(i) then
                    cnt = cnt+1
                end if
            next
        next
        issolvable = (cnt mod 2 = 0)
    end function

    private function lpad(byval istr, byval length, byval padchar)
        lpad = right(string(length, padchar) & istr, length)
    end function

    public sub printboard
        dim i
        for i = 0 to m_degree*m_degree-1
            wscript.stdout.write lpad(m_board(i), 3, " ")
            if i mod m_degree = m_degree-1 then
                wscript.stdout.writeline
            end if
        next
    end sub

    public sub printwalk
        dim i, j
        for i = 0 to m_degree*m_degree-1
            for j = 0 to m_degree*m_degree-1
                wscript.stdout.write lpad(m_walk(i, j), 3, " ")
            next
            wscript.stdout.writeline
        next
    end sub

    public function getboardcost(byref board())
        dim j, cost : cost = 0
        for j = 0 to m_degree*m_degree-1
            cost = cost + m_walk(board(j), j)
        next
        getboardcost = cost
    end function

end class

call main
