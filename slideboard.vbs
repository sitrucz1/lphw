'
' A slide puzzle board
'
option explicit

class tboard

    public m_degree
    public m_board
    public m_blank

    public function init(byval degree)
        m_degree = iif(degree < 2 or degree > 5, 3, degree)
        m_board = makeboard(degree)
        m_blank = degree*degree-1
        ' wscript.echo join(m_board, " ")
        set init = me
    end function

    private function iif(byval condition, byval truecond, byval falsecond)
        if condition then
            iif = truecond
        else
            iif = falsecond
        end if
    end function

    private function makeboard(byval degree)
        dim i, arr()
        redim arr(degree*degree-1)
        for i = 0 to degree*degree-2
            arr(i) = i+1
        next
        arr(degree*degree-1) = 0
        makeboard = arr
    end function

    public function clone
        dim board : set board = new tboard
        board.m_degree = me.m_degree
        board.m_board = me.m_board
        board.m_blank = me.m_blank
        set clone = board
    end function

    public function tostring
        tostring = join(m_board, " ")
    end function

    public function movevalid(byval way)
        dim row, col : row = getrow(m_blank) : col = getcol(m_blank)
        movevalid = (row <> 0 and way = mvup) or (row <> m_degree-1 and way = mvdown) _
                 or (col <> 0 and way = mvleft) or (col <> m_degree-1 and way = mvright)
    end function

    public function move(byval way)
        if not movevalid(way) then
            move = false
            exit function
        end if
        select case way
            case mvup
                m_board(m_blank) = m_board(m_blank - m_degree)
                m_blank = m_blank - m_degree
                m_board(m_blank) = 0
            case mvdown
                m_board(m_blank) = m_board(m_blank + m_degree)
                m_blank = m_blank + m_degree
                m_board(m_blank) = 0
            case mvleft
                m_board(m_blank) = m_board(m_blank-1)
                m_blank = m_blank-1
                m_board(m_blank) = 0
            case mvright
                m_board(m_blank) = m_board(m_blank+1)
                m_blank = m_blank+1
                m_board(m_blank) = 0
        end select
        move = true
    end function

    public sub shuffle
        dim i, way, prev : prev = mvnull
        randomize
        for i = 0 to m_degree*m_degree*100-1
            way = int(mvcnt * rnd)
            do until movevalid(way) and way <> prev
                way = (way+1) mod mvcnt
            loop
            move(way)
            prev = way
        next
    end sub

    private function getrow(byval n)
        getrow = n \ m_degree
    end function

    private function getcol(byval n)
        getcol = n mod m_degree
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
        wscript.echo "+" & string(3*m_degree-1, "-") & "---+"
        for i = 0 to m_degree*m_degree-1
            if i mod (m_degree) = 0 then
                wscript.stdout.write "|"
            end if
            wscript.stdout.write lpad(m_board(i), 3, " ")
            if i mod m_degree = m_degree-1 then
                wscript.stdout.writeline "  |"
            end if
        next
        wscript.echo "+" & string(3*m_degree-1, "-") & "---+"
        wscript.stdout.writeline
    end sub

    ' public sub printwalk
    '     dim i, j
    '     for i = 0 to m_degree*m_degree-1
    '         for j = 0 to m_degree*m_degree-1
    '             wscript.stdout.write lpad(m_walk(i, j), 3, " ")
    '         next
    '         wscript.stdout.writeline
    '     next
    ' end sub

    ' public function getboardcost
    '     dim j, cost : cost = 0
    '     for j = 0 to m_degree*m_degree-1
    '         cost = cost + m_walk(m_board(j), j)
    '     next
    '     getboardcost = cost
    ' end function

end class
