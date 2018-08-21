option explicit

const QSIZE = 100
const SSIZE = 50

sub main()
    includefile "queue.vbs"     ' tqueue and tstack
    dim nil : set nil = new ttbstnode : nil.m_data = 0 : set nil.m_child(0) = nil : set nil.m_child(1) = nil
    dim tree : set tree = (new ttbst).init(nil)
    set tree.m_root = (new ttbstnode).init(5, nil)
    set tree.m_root.m_child(0) = (new ttbstnode).init(3, nil)
    set tree.m_root.m_child(0).m_child(0) = (new ttbstnode).init(1, nil)
    set tree.m_root.m_child(0).m_child(1) = (new ttbstnode).init(4, nil)
    set tree.m_root.m_child(0).m_child(0).m_child(1) = (new ttbstnode).init(2, nil)
    set tree.m_root.m_child(1) = (new ttbstnode).init(7, nil)
    set tree.m_root.m_child(1).m_child(1) = (new ttbstnode).init(10, nil)
    set tree.m_root.m_child(1).m_child(1).m_child(1) = (new ttbstnode).init(15, nil)
    set tree.m_root.m_child(1).m_child(1).m_child(0) = (new ttbstnode).init(8, nil)
    set tree.m_root.m_child(1).m_child(1).m_child(0).m_child(1) = (new ttbstnode).init(9, nil)
    set tree.m_root.m_child(1).m_child(1).m_child(1).m_child(1) = (new ttbstnode).init(18, nil)
    set tree.m_root.m_child(1).m_child(1).m_child(1).m_child(1).m_child(1) = (new ttbstnode).init(19, nil)
    '      5
    '    /   \
    '   3     7
    '  / \     \
    ' 1   4    10
    ' \       / \
    '  2     8  15
    '        \   \
    '         9  18
    '             \
    '             19
    tree.preorderi
    tree.inorderi
    tree.postorderi
    tree.levelorderi
    wscript.echo tree.heighti
    wscript.echo tree.istbst(tree.m_root)
    tree.makethreaded
    tree.inorderit
end sub

sub includefile(fspec)
    executeglobal createobject("scripting.filesystemobject").opentextfile(fspec).readall()
end sub

class ttbstnode

    public m_data
    public m_child(1)
    public m_threaded

    public function init(byval data, byval nil)
        m_data = data
        set m_child(0) = nil
        set m_child(1) = nil
        m_threaded = false
        set init = me
    end function

end class

class ttbst

    public m_root
    public m_cnt
    public m_nil

    private sub class_initialize()
        set m_nil = new ttbstnode
        m_nil.m_data = 0
        set m_nil.m_child(0) = m_nil
        set m_nil.m_child(1) = m_nil
        set m_root = m_nil
        m_cnt = 0
    end sub

    public function init(byval nil)
        set m_nil = nil
        set m_root = nil
        m_cnt = 0
        set init = me
    end function

    private function isless(a, b)
        if a is m_nil or b is m_nil then
            isless = false
        else
            isless = (a.m_data < b.m_data)
        end if
    end function

    private function max(a, b)
        if a > b then
            max = a
        else
            max = b
        end if
    end function

    public function istbst(node)
        if node is m_nil then
            istbst = true
        elseif isless(node, node.m_child(0)) or isless(node.m_child(1), node) then
            wscript.echo "ERROR: not a BST"
            istbst = false
        else
            istbst = istbst(node.m_child(0)) and istbst(node.m_child(1))
        end if
    end function

    public function isempty
        isempty = m_root is m_nil
    end function

    public function rotate(byval node, byval way)
        dim root : set root = node.m_child(way xor 1)
        set node.m_child(way xor 1) = root.m_child(way)
        set root.m_child(way) = node
        set rotate = root
    end function

    public sub bstdsw
        ' Day-Stout-Warren Algorithm
        dim head, node, parent, n, m
        set head = (new ttbstnode).init(0, m_nil)
        set head.m_child(1) = m_root

        ' create the vine to the right
        n = 0
        set parent = head
        set node = head.m_child(1)
        do until node is m_nil
            do until node.m_child(0) is m_nil
                set node = rotate(node, 1)
            loop
            set parent.m_child(1) = node
            n = n+1
            set parent = node
            set node = node.m_child(1)
        loop

        ' balance the tree
        m = 2 ^ int(log(n+1) / log(2)) - 1
        wscript.echo "n, m, n-m => ", n, m, n-m
        bstdswcompress head, n-m
        do while m > 1
            m = m \ 2
            bstdswcompress head, m
        loop

        ' update root
        set m_root = head.m_child(1)
    end sub

    public sub bstdswcompress(byval head, byval n)
        dim node, parent, i
        set parent = head
        set node = head.m_child(1)
        for i = 1 to n
            set node = rotate(node, 0)
            set parent.m_child(1) = node
            set parent = node
            set node = node.m_child(1)
        next
    end sub

    public function tbstfindi(data)
        dim node, x, way : set node = m_root : set x = m_nil
        do until node is m_nil
            if node.m_data <= data then
                way = 1
                set x = node
            else
                way = 0
            end if
            set node = node.m_child(way)
        loop
        if not x is m_nil and x.m_data = data then
            set node = x
        end if
        set tbstfindi = node
    end function

    public function tbstputi(byval data)
        dim node, head, parent, x, way
        set head = (new tbstnode).init(0, m_nil)
        set head.m_child(1) = m_root
        way = 1
        set x = m_nil
        set parent = head
        set node = m_root
        do until node is m_nil
            if node.m_data <= data then
                way = 1
                set x = node
            else
                way = 0
            end if
            set parent = node
            set node = node.m_child(way)
        loop
        if not x is m_nil and x.m_data = data then
            set node = x ' already in tree
        else
            set node = (new ttbstnode).init(data, m_nil)
            set parent.m_child(way) = node
            set m_root = head.m_child(1)
        end if
        set tbstputi = node
    end function

    public function tbstdeletei(byval data)
        dim node, head, parent, last, x, way, pway
        set head = (new ttbstnode).init(0, m_nil) ' fake root so we dont code for root
        set head.m_child(1) = m_root
        way = 1
        set x = m_nil   ' candidate for deletion
        set last = head ' leaf node to be deleted
        set node = m_root
        do until node is m_nil
            pway = way
            set parent = last
            set last = node
            if node.m_data <= data then
                way = 1
                set x = node
            else
                way = 0
            end if
            set node = node.m_child(way)
        loop
        if x is m_nil or x.m_data <> data then
            set node = m_nil    ' not found
        else
            set node = last     ' deleted node
            x.m_data = last.m_data
            set parent.m_child(pway) = last.m_child(way xor 1)
            set m_root = head.m_child(1)
        end if
        set tbstdeletei = node
    end function

    public sub makethreaded()
        dim node, visited : set node = m_root : visited = false
        dim ss(), st : redim ss(SSIZE-1) : st = 0   ' stack variables
        ' set ss(st) = m_nil : st = st+1              ' push nil sentinel node
        do until node is m_nil
            do until node.m_child(0) is m_nil or visited
                ' wscript.echo node.m_data
                set ss(st) = node : st = st+1       ' push node
                set node = node.m_child(0)          ' left child
            loop
            ' wscript.echo node.m_data
            if node.m_child(1) is m_nil and st > 0 then
                node.m_threaded = true
                st = st-1 : set node.m_child(1) = ss(st) ' pop node
                set node = node.m_child(1)          ' right threaded child
                visited = true
            else
                set node = node.m_child(1)          ' right child
                visited = false
            end if
        loop
    end sub

    public sub preorderi()
        dim node, ss(), st : redim ss(SSIZE-1) : st = 0 ' stack variables
        set ss(st) = m_root : st = st+1                 ' push root
        do until st = 0 ' stack is empty
            st = st-1 : set node = ss(st)               ' pop node
            do until node is m_nil
                wscript.stdout.write node.m_data & " "
                if not node.m_child(1) is m_nil then
                    set ss(st) = node.m_child(1) : st = st+1 ' push right node
                end if
                set node = node.m_child(0)              ' left child
            loop
        loop
        wscript.stdout.writeline
    end sub

    public sub inorderi()
        dim ss(), st : redim ss(SSIZE-1) : st = 0   ' stack variables
        dim node : set node = m_root
        do until node is m_nil and st = 0           ' stack empty
            do until node is m_nil
                set ss(st) = node : st = st+1
                set node = node.m_child(0)          ' left child
            loop
            st = st-1 : set node = ss(st)           ' pop node
            wscript.stdout.write node.m_data & "," & node.m_threaded & " "
            set node = node.m_child(1)              ' right child
        loop
        wscript.stdout.writeline
    end sub

    public sub inorderit()
        dim node, visited : set node = m_root : visited = false
        do until node is m_nil
            do until node.m_child(0) is m_nil or visited
                set node = node.m_child(0)          ' left child
            loop
            wscript.stdout.write node.m_data & " "
            visited = node.m_threaded
            set node = node.m_child(1)              ' right child
        loop
        wscript.stdout.writeline
    end sub

    public sub postorderi()
        dim ss(), st : redim ss(SSIZE-1) : st = 0 ' stack variables
        dim node, prev : set node = m_root : set prev = m_nil
        do until node is m_nil and st = 0       ' stack empty
            do until node is m_nil
                set ss(st) = node : st = st+1   ' stack push
                set node = node.m_child(0)      ' left child
            loop
            st = st-1 : set node = ss(st)       ' stack pop
            if node.m_child(1) is m_nil or node.m_child(1) is prev then
                wscript.stdout.write node.m_data & " "
                set prev = node
                set node = m_nil
            else
                set ss(st) = node : st = st+1   ' stack push
                set node = node.m_child(1)      ' right child
            end if
        loop
        wscript.stdout.writeline
    end sub

    public sub levelorderi()
        dim qq(), qh, qt, qc : redim qq(QSIZE-1) : qh = 0 : qt = 0 : qc = 0 ' queue variables
        if m_root is m_nil then
            exit sub
        end if
        set qq(qh) = m_root : qh = (qh+1) mod QSIZE : qc = qc+1 ' enqueue root
        do until qc = 0 ' queue empty
            dim node : set node = qq(qt) : qt = (qt+1) mod QSIZE : qc = qc-1 ' dequeue
            wscript.stdout.write node.m_data & " "
            if not node.m_child(0) is m_nil then
                set qq(qh) = node.m_child(0) : qh = (qh+1) mod QSIZE : qc = qc+1 ' enqueue left
            end if
            if not node.m_child(1) is m_nil then
                set qq(qh) = node.m_child(1) : qh = (qh+1) mod QSIZE : qc = qc+1 ' enqueue right
            end if
        loop
        wscript.stdout.writeline
    end sub

    public function heighti()
        dim qq(), qh, qt, qc : redim qq(QSIZE-1) : qh = 0 : qt = 0 : qc = 0 ' queue variables
        if m_root is m_nil then
            heighti = 0
            exit function
        end if
        set qq(qh) = m_root : qh = (qh+1) mod QSIZE : qc = qc+1 ' enqueue root
        dim hcnt, lcnt : hcnt = 0 : lcnt = qc
        do until qc = 0 ' queue empty
            do until lcnt = 0
                dim node : set node = qq(qt) : qt = (qt+1) mod QSIZE : qc = qc-1     ' dequeue
                if not node.m_child(0) is m_nil then
                    set qq(qh) = node.m_child(0) : qh = (qh+1) mod QSIZE : qc = qc+1 ' enqueue left
                end if
                if not node.m_child(1) is m_nil then
                    set qq(qh) = node.m_child(1) : qh = (qh+1) mod QSIZE : qc = qc+1 ' enqueue right
                end if
                lcnt = lcnt-1
            loop
            hcnt = hcnt+1
            lcnt = qc ' set level count to next level size
        loop
        heighti = hcnt
    end function

end class

call main()
