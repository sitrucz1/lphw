option explicit

const QSIZE = 100
const SSIZE = 50

sub main()
    includefile "queue.vbs"     ' tqueue and tstack
    dim nil : set nil = new tbstnode : nil.m_data = 0 : set nil.m_child(0) = nil : set nil.m_child(1) = nil
    dim tree : set tree = (new tbst).init(nil)
    set tree.m_root = (new tbstnode).init(5, nil)
    set tree.m_root.m_child(0) = (new tbstnode).init(3, nil)
    set tree.m_root.m_child(0).m_child(0) = (new tbstnode).init(1, nil)
    set tree.m_root.m_child(0).m_child(1) = (new tbstnode).init(4, nil)
    set tree.m_root.m_child(0).m_child(0).m_child(1) = (new tbstnode).init(2, nil)
    set tree.m_root.m_child(1) = (new tbstnode).init(7, nil)
    set tree.m_root.m_child(1).m_child(1) = (new tbstnode).init(10, nil)
    set tree.m_root.m_child(1).m_child(1).m_child(1) = (new tbstnode).init(15, nil)
    set tree.m_root.m_child(1).m_child(1).m_child(0) = (new tbstnode).init(8, nil)
    set tree.m_root.m_child(1).m_child(1).m_child(0).m_child(1) = (new tbstnode).init(9, nil)
    set tree.m_root.m_child(1).m_child(1).m_child(1).m_child(1) = (new tbstnode).init(18, nil)
    set tree.m_root.m_child(1).m_child(1).m_child(1).m_child(1).m_child(1) = (new tbstnode).init(19, nil)
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
    ' tree.preorderr
    tree.preorderi
    ' tree.inorderr
    tree.inorderi
    ' tree.postorderr
    tree.postorderi
    tree.levelorderi
    ' wscript.echo tree.heightr
    ' wscript.echo tree.heighti
    wscript.echo tree.heighti
    wscript.echo tree.isbst(tree.m_root)
    dim small, big : set small = (new tbst).init(nil) : set big = (new tbst).init(nil)
    ' tree.bstsplit tree.m_root, 9, small, big
    tree.bstspliti tree.m_root, 9, small, big
    small.levelorderi
    big.levelorderi
    wscript.echo small.isbst(small.m_root)
    wscript.echo big.isbst(big.m_root)
    ' tree.bstdsw
    ' tree.levelorderi
    ' wscript.echo tree.isbst(tree.m_root)
    ' wscript.echo tree.heighti
    ' if tree.bstfindr(7) is m_nil then
    '     wscript.echo "not found"
    ' else
    '     wscript.echo "found"
    ' end if
    ' if tree.bstfindr(2) is m_nil then
    '     wscript.echo "not found"
    ' else
    '     wscript.echo "found"
    ' end if
    ' if tree.bstfindr(6) is m_nil then
    '     wscript.echo "not found"
    ' else
    '     wscript.echo "found"
    ' end if
    if tree.bstfindi(2) is nil then
        wscript.echo "not found"
    else
        wscript.echo "found"
    end if
    set tree = nothing
    set tree = (new tbst).init(nil)
    tree.bstputr(5)
    tree.bstputr(4)
    tree.bstputr(1)
    tree.bstputr(2)
    tree.bstputr(7)
    tree.bstputr(7)
    tree.levelorderi
    tree.bstdeleter(2)
    tree.levelorderi
    tree.bstdeleter(5)
    tree.levelorderi
    wscript.echo tree.isbst(tree.m_root)
    set tree = nothing
    set tree = (new tbst).init(nil)
    tree.bstputi(5)
    tree.bstputi(4)
    tree.bstputi(1)
    tree.bstputi(2)
    tree.bstputi(7)
    tree.levelorderi
    wscript.echo tree.isbst(tree.m_root)
    tree.bstdeletei(5)
    tree.levelorderi
    wscript.echo tree.isbst(tree.m_root)
    tree.bstdeletei(1)
    tree.levelorderi
    wscript.echo tree.isbst(tree.m_root)
    tree.bstdeletei(5)
    tree.levelorderi
    wscript.echo tree.isbst(tree.m_root)
    do until tree.isempty or not tree.isbst(tree.m_root)
        tree.bstdeletei(tree.m_root.m_data)
        tree.levelorderi
    loop
end sub

sub includefile(fspec)
    executeglobal createobject("scripting.filesystemobject").opentextfile(fspec).readall()
end sub

class tbstnode

    public m_data
    public m_child(1)

    public function init(byval data, byval nil)
        m_data = data
        set m_child(0) = nil
        set m_child(1) = nil
        set init = me
    end function

end class

class tbst

    public m_root
    public m_cnt
    public m_nil

    private sub class_initialize()
        set m_nil = new tbstnode
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

    public function isbst(node)
        if node is m_nil then
            isbst = true
        elseif isless(node, node.m_child(0)) or isless(node.m_child(1), node) then
            wscript.echo "ERROR: not a BST"
            isbst = false
        else
            isbst = isbst(node.m_child(0)) and isbst(node.m_child(1))
        end if
    end function

    public function isempty
        isempty = m_root is m_nil
    end function

    public function bstfindr(data)
        set bstfindr = bstfindnoder(m_root, data)
    end function

    private function bstfindnoder(byval node, byval data)
        if node is m_nil then
            set bstfindnoder = node
        elseif node.m_data = data then
            set bstfindnoder = node
        else
            dim way : way = (node.m_data < data) and 1
            set bstfindnoder = bstfindnoder(node.m_child(way), data)
        end if
    end function

    public sub bstsplit(byval node, byval data, byref s1, byref s2)
        if node is m_nil then
            set s1.m_root = m_nil
            set s2.m_root = m_nil
        elseif node.m_data = data then
            wscript.echo "node => ", node.m_data
            set s2.m_root = node.m_child(1) ' node gets modified so have to assign s2 first
            set s1.m_root = bstjoin(node.m_child(0), node, s1.m_root)
            wscript.echo s1.m_root.m_data
        else
            dim way : way = (node.m_data < data) and 1
            wscript.echo "node, way => ", node.m_data, way
            bstsplit node.m_child(way), data, s1, s2
            if way = 1 then
                set s1.m_root = bstjoin(node.m_child(0), node, s1.m_root)
                wscript.echo s1.m_root.m_data
            else
                set s2.m_root = bstjoin(s2.m_root, node, node.m_child(1))
                wscript.echo s2.m_root.m_data
            end if
        end if
    end sub

    public sub bstspliti(byval node, byval data, byref s1, byref s2)
        dim k, na(100), wa(100), x
        x = 0
        k = 0
        set na(k) = m_nil : wa(k) = 1
        do until node is m_nil
            k = k+1
            set na(k) = node
            if node.m_data <= data then
                wa(k) = 1
                x = k
            else
                wa(k) = 0
            end if
            set node = node.m_child(wa(k))
        loop
        set s1.m_root = m_nil
        set s2.m_root = m_nil
        if x > 0 and na(x).m_data = data then
            k = x
            set s2.m_root = na(k).m_child(1)
        end if
        for k = k to 1 step -1
            if wa(k) = 1 then
                set s1.m_root = bstjoin(na(k).m_child(0), na(k), s1.m_root)
            else
                set s2.m_root = bstjoin(s2.m_root, na(k), na(k).m_child(1))
            end if
        next
    end sub

    public function bstjoin(byval s1, byval node, byval s2)
        set node.m_child(0) = s1
        set node.m_child(1) = s2
        set bstjoin = node
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
        set head = (new tbstnode).init(0, m_nil)
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

    public function bstfindi(data)
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
        set bstfindi = node
    end function

    public function bstputr(byval data)
        set m_root = bstputitemr(m_root, data)
        set bstputr = m_root
    end function

    private function bstputitemr(byval node, byval data)
        if node is m_nil then
            set node = (new tbstnode).init(data, m_nil)
            set bstputitemr = node
        elseif node.m_data = data then
            set bstputitemr = node
        else
            dim way : way = (node.m_data < data) and 1
            set node.m_child(way) = bstputitemr(node.m_child(way), data)
            set bstputitemr = node
        end if
    end function

    public function bstputi(byval data)
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
            set node = (new tbstnode).init(data, m_nil)
            set parent.m_child(way) = node
            set m_root = head.m_child(1)
        end if
        set bstputi = node
    end function

    public function bstdeleter(byval data)
        set m_root = bstdeleteitemr(m_root, data)
        set bstdeleter = m_root
    end function

    private function bstdeleteitemr(byval node, byval data)
        if node is m_nil then
            set bstdeleteitemr = node
        elseif node.m_data <> data then
            dim way : way = (node.m_data < data) and 1
            set node.m_child(way) = bstdeleteitemr(node.m_child(way), data)
            set bstdeleteitemr = node
        else ' found it
            if node.m_child(0) is m_nil then  ' one child
                set bstdeleteitemr = node.m_child(1)
            elseif node.m_child(1) is m_nil then  ' one child
                set bstdeleteitemr = node.m_child(0)
            else ' 2 children
                dim succ : set succ = node.m_child(1)
                do until succ.m_child(0) is m_nil
                    set succ = succ.m_next(0)
                loop
                node.m_data = succ.m_data
                set node.m_child(1) = bstdeleteitemr(node.m_child(1), succ.m_data)
                set bstdeleteitemr = node
            end if
        end if
    end function

    public function bstdeletei(byval data)
        dim node, head, parent, last, x, way, pway
        set head = (new tbstnode).init(0, m_nil) ' fake root so we dont code for root
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
        set bstdeletei = node
    end function

    public sub preorderr()
        preorderrnode(m_root)
        wscript.stdout.writeline
    end sub

    private sub preorderrnode(byval node)
        if not node is m_nil then
            wscript.stdout.write node.m_data & " "
            preorderrnode(node.m_child(0))
            preorderrnode(node.m_child(1))
        end if
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

    public sub inorderr()
        inorderrnode(m_root)
        wscript.stdout.writeline
    end sub

    private sub inorderrnode(byval node)
        if not node is m_nil then
            inorderrnode(node.m_child(0))
            wscript.stdout.write node.m_data & " "
            inorderrnode(node.m_child(1))
        end if
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
            wscript.stdout.write node.m_data & " "
            set node = node.m_child(1)              ' right child
        loop
        wscript.stdout.writeline
    end sub

    public sub postorderr()
        postorderrnode(m_root)
        wscript.stdout.writeline
    end sub

    private sub postorderrnode(byval node)
        if not node is m_nil then
            postorderrnode(node.m_child(0))
            postorderrnode(node.m_child(1))
            wscript.stdout.write node.m_data & " "
        end if
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

    public function heightr()
        heightr = heightrnode(m_root)
    end function

    private function heightrnode(node)
        if node is m_nil then
            heightrnode = 0
        else
            dim lh, rh
            lh = heightrnode(node.m_child(0))
            rh = heightrnode(node.m_child(1))
            heightrnode = 1 + max(lh, rh)
        end if
    end function

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
