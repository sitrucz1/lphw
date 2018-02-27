'
' A slide puzzle solver
'
option explicit

const mvnull  = 0
const mvup    = 1
const mvright = 2
const mvdown  = 3
const mvleft  = 4

sub main()
    ' includefile "queue.vbs"     ' tqueue and tstack
    dim solver : set solver = new tslidesolver.init(4)
end sub

sub includefile(fspec)
    executeglobal createobject("scripting.filesystemobject").opentextfile(fspec).readall()
end sub

class tboard

    public m_degree
    public m_board
    public m_walk
    public m_blank

    public function init(byval degree, byval board, byval way)
        if degree < 2 or degree > 5 then
            m_degree = 3
        else
            m_degree = degree
        end if
        if isobject(board) then
            set m_board = board.m_board
            m_degree = board.m_degree
            m_blank = board.m_blank
        else
            m_board = array()
            redim m_board(m_degree*m_degree-1)
            dim i
            for i = 0 to m_degree*m_degree-2
                m_board(i) = i+1
            next
            m_board(m_degree*m_degree-1) = 0
            m_blank = m_degree*m_degree-1
        end if
        ' printboard
        if isobject(board) then
            set m_walk = board.m_walk
        else
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
        end if
        ' printwalk
        wscript.stdout.writeline getboardcost(m_board)
        wscript.stdout.writeline issolvable
        wscript.stdout.writeline issolved
        set init = me
    end function

    public function move(byval way)
        dim row, col : row = row(m_blank) : col = col(m_blank)
        if (row = 0 and way = mvup) or (row = m_degree-1 and way = mvdown) or (col = 0 and way = mvleft) or (col = m_degree-1 and way = mvright) then
            move = false
            exit function
        end if
        select case way
            case mvup
                m_items(m_blank) = m_items(m_blank - m_degree)
                m_items(m_blank - m_degree) = 0
            case mvdown
                m_items(m_blank) = m_items(m_blank + m_degree)
                m_items(m_blank + m_degree) = 0
            case mvleft
                m_items(m_blank) = m_items(m_blank-1)
                m_items(m_blank-1) = 0
            case mvright
                m_items(m_blank) = m_items(m_blank+1)
                m_items(m_blank+1) = 0
        end select
        move = true
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

class tslidesolver

    public function init(byval degree)
        set init = me
    end function

end class

call main
