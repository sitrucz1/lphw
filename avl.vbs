option explicit

sub main()
    includefile "queue.vbs"     ' tqueue and tstack
    dim tree : set tree = new tavl
    dim i : i = 0
    randomize timer
    do
        i = i+1
        dim j : j = int(rnd*100)
        tree.avlputi(j)
    loop until i > 50 or not tree.isavl
    ' tree.avlputi(91)
    ' tree.avlputi(23)
    ' tree.avlputi(99)
    ' tree.avlputi(33)
    ' tree.avlputi(17)
    ' tree.avlputi(80)
    ' tree.avlputi(7)
    tree.print
    wscript.echo "inserting done"
    ' wscript.quit

    do until tree.isempty or not tree.isavl
        wscript.echo "Deleting => ", tree.m_root.m_data
        tree.avldeletei(tree.m_root.m_data)
        ' tree.print
    loop
    tree.print
    wscript.quit

    set tree.m_root = (new tavlnode).init(5)
    set tree.m_root.m_child(0) = (new tavlnode).init(3)
    set tree.m_root.m_child(0).m_child(0) = (new tavlnode).init(1)
    set tree.m_root.m_child(0).m_child(1) = (new tavlnode).init(4)
    set tree.m_root.m_child(0).m_child(0).m_child(1) = (new tavlnode).init(2)
    set tree.m_root.m_child(1) = (new tavlnode).init(7)
    set tree.m_root.m_child(1).m_child(1) = (new tavlnode).init(10)
    set tree.m_root.m_child(1).m_child(1).m_child(1) = (new tavlnode).init(15)
    set tree.m_root.m_child(1).m_child(1).m_child(0) = (new tavlnode).init(8)
    set tree.m_root.m_child(1).m_child(1).m_child(0).m_child(1) = (new tavlnode).init(9)
    set tree.m_root.m_child(1).m_child(1).m_child(1).m_child(1) = (new tavlnode).init(18)
    set tree.m_root.m_child(1).m_child(1).m_child(1).m_child(1).m_child(1) = (new tavlnode).init(19)
    tree.print
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
    tree.preorderr
    tree.preorderi
    tree.inorderr
    tree.inorderi
    tree.postorderr
    tree.postorderi
    tree.levelorderi
    wscript.echo tree.heightr
    wscript.echo tree.heighti
    wscript.echo tree.heightiq
    wscript.echo tree.isavl
    if tree.avlfindr(7) is nothing then
        wscript.echo "not found"
    else
        wscript.echo "found"
    end if
    if tree.avlfindr(2) is nothing then
        wscript.echo "not found"
    else
        wscript.echo "found"
    end if
    if tree.avlfindr(6) is nothing then
        wscript.echo "not found"
    else
        wscript.echo "found"
    end if
    if tree.avlfindi(2) is nothing then
        wscript.echo "not found"
    else
        wscript.echo "found"
    end if

    set tree = nothing
    set tree = new tavl
    tree.avlputr(5)
    tree.avlputr(4)
    tree.avlputr(1)
    tree.avlputr(2)
    tree.avlputr(7)
    tree.avlputr(7)
    tree.avlputr(10)
    ' tree.levelorderi
    tree.print
    tree.avldeleter(2)
    ' tree.levelorderi
    tree.print
    tree.avldeleter(5)
    ' tree.levelorderi
    tree.print
    wscript.echo tree.isavl
    wscript.quit

    set tree = nothing
    set tree = new tavl
    tree.avlputi(5)
    tree.avlputi(4)
    tree.avlputi(1)
    tree.avlputi(2)
    tree.avlputi(7)
    tree.levelorderi
    wscript.echo tree.isavl
    tree.avldeletei(1)
    tree.levelorderi
    tree.avldeletei(5)
    tree.levelorderi
    wscript.echo tree.isavl
end sub

sub includefile(fspec)
    executeglobal createobject("scripting.filesystemobject").opentextfile(fspec).readall()
end sub

class tavlnode

    public m_data
    public m_bal
    public m_child(1)

    public function init(byval data)
        m_data = data
        m_bal = 0
        set m_child(0) = nothing
        set m_child(1) = nothing
        set init = me
    end function

end class

class tavlstacknode

    public m_data
    public m_way

    public function init(byval data, byval way)
        set m_data = data
        m_way = way
        set init = me
    end function

end class

class tavl

    public m_root
    public m_cnt

    private sub class_initialize()
        set m_root = nothing
        m_cnt = 0
    end sub

    private function isless(a, b)
        if a is nothing or b is nothing then
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

    private function iff(condition, a, b)
        if condition then
            iff = a
        else
            iff = b
        end if
    end function

    public function isempty()
        isempty = (m_root is nothing)
    end function

    public function isavl()
        isavl = (isavlnode(m_root) <> -1)
    end function

    private function isavlnode(byval node)
        if node is nothing then
            isavlnode = 0
        elseif isless(node, node.m_child(0)) or isless(node.m_child(1), node) then
            wscript.echo "ERROR: not a BST", node.m_data, node.m_bal
            isavlnode = -1
        elseif node.m_bal < -1 or node.m_bal > 1 then
            wscript.echo "ERROR: node balance is out of range", node.m_data, node.m_bal
            isavlnode = -1
        else
            dim lh : lh = isavlnode(node.m_child(0))
            dim rh : rh = isavlnode(node.m_child(1))
            if lh = -1 or rh = -1 then
                isavlnode = -1  ' an error above already trapped this dont echo
            elseif node.m_bal <> (rh - lh) then
                wscript.echo "ERROR: node balance doesn't match heights", node.m_data, node.m_bal
                isavlnode = -1
            else
                isavlnode = 1 + max(lh, rh)
            end if
        end if
    end function

    public function rotate(byval node, byval way)
        dim root : set root = node.m_child(way xor 1)
        set node.m_child(way xor 1) = root.m_child(way)
        set root.m_child(way) = node
        set rotate = root
    end function

    public function avlfindr(data)
        set avlfindr = avlfindnoder(m_root, data)
    end function

    private function avlfindnoder(byval node, byval data)
        if node is nothing then
            set avlfindnoder = node
        elseif node.m_data = data then
            set avlfindnoder = node
        else
            dim way : way = (node.m_data < data) and 1
            set avlfindnoder = avlfindnoder(node.m_child(way), data)
        end if
    end function

    public function avlfindi(data)
        dim node : set node = m_root
        do until node is nothing
            if node.m_data = data then
                exit do
            end if
            dim way : way = (node.m_data < data) and 1
            set node = node.m_child(way)
        loop
        set avlfindi = node
    end function

    public function avlputr(byval data)
        dim done : done = false
        set m_root = avlputitemr(m_root, data, done)
        set avlputr = m_root
    end function

    private function avlputitemr(byval node, byval data, byref done)
        if node is nothing then
            set node = (new tavlnode).init(data)
            set avlputitemr = node
        elseif node.m_data = data then
            done = true
            set avlputitemr = node
        else
            dim way : way = (node.m_data < data) and 1
            set node.m_child(way) = avlputitemr(node.m_child(way), data, done)
            ' rebalance
            if not done then
                node.m_bal = node.m_bal + iif(way = 0, -1, 1)
                if node.m_bal = 0 then
                    done = true
                elseif node.m_bal = 2 or node.m_bal = -2 then   ' rotation is needed
                    set node = putitembal(node, way)
                    done = true
                end if
            end if
            set avlputitemr = node
        end if
    end function

    private function putitembal(byval node, byval way)
        dim bal : bal = iff(way = 0, -1, 1)
        if bal = node.m_child(way).m_bal then  ' single rotation
            set node = rotate(node, way xor 1)
            node.m_bal = 0 : node.m_child(way xor 1).m_bal = 0
        else ' double rotation
            set node.m_child(way) = rotate(node.m_child(way), way)
            set node = rotate(node, way xor 1)
            set node = adjustbal(node, way)
        end if
        set putitembal = node
    end function

    private function deleteitembal(byval node, byval way, byref done)
        if done then
            set deleteitembal = node
            exit function
        end if
        node.m_bal = node.m_bal + iff(way = 0, 1, -1)
        wscript.echo "node, nodebal, way => ", node.m_data, node.m_bal, way
        if node.m_bal = -1 or node.m_bal = 1 then
            done = true
        elseif node.m_bal = -2 or node.m_bal = 2 then
            dim bal : bal = iff(way = 0, -1, 1)
            wscript.echo "bal => ", bal
            if bal <> node.m_child(way xor 1).m_bal then  ' single rotation
                wscript.echo "* single rotate => ", node.m_data, way
                set node = rotate(node, way)
                if node.m_bal = 0 then
                    node.m_bal = bal
                    node.m_child(way).m_bal = -bal
                    done = true ' b/c node balance <> 0
                else
                    node.m_bal = 0
                    node.m_child(way).m_bal = 0
                end if
            else ' double rotation
                wscript.echo "** double rotate => ", node.m_data, way
                set node.m_child(way xor 1) = rotate(node.m_child(way xor 1), way xor 1)
                set node = rotate(node, way)
                set node = adjustbal(node, way)
            end if
        end if
        set deleteitembal = node
    end function

    private function adjustbal(byval node, byval way)
        dim bal : bal = iff(way = 0, -1, 1)
        wscript.echo "adjustbal => ", bal, node.m_bal
        if bal = node.m_bal then
            node.m_child(way xor 1).m_bal = -bal
            node.m_child(way).m_bal = 0
        elseif bal = -node.m_bal then
            node.m_child(way xor 1).m_bal = 0
            node.m_child(way).m_bal = bal
        else ' 0
            node.m_child(way xor 1).m_bal = 0
            node.m_child(way).m_bal = 0
        end if
        node.m_bal = 0
        set adjustbal = node
    end function

    public function avlputi(byval data)
        dim node, parent, way : set node = m_root : set parent = nothing
        dim critnode, pcritnode : set critnode = m_root : set pcritnode = nothing
        do until node is nothing
            if node.m_data = data then
                set avlputi = node
                exit function
            end if
            if node.m_bal <> 0 then
                set critnode = node
                set pcritnode = parent
            end if
            set parent = node
            way = (node.m_data < data) and 1
            set node = node.m_child(way)
        loop
        set node = (new tavlnode).init(data)
        if parent is nothing then
            set m_root = node
        else
            set parent.m_child(way) = node
            ' rebalance
            dim n : set n = critnode
            do while not n is node
                way = (n.m_data < data) and 1
                n.m_bal = n.m_bal + iff(way = 0, -1, 1)
                set n = n.m_child(way)
            loop
            if critnode.m_bal = 2 or critnode.m_bal = -2 then   ' rotation is needed
                way = (critnode.m_data < data) and 1
                set critnode = putitembal(critnode, way)
                if pcritnode is nothing then
                    set m_root = critnode
                else
                    way = (pcritnode.m_data < data) and 1
                    set pcritnode.m_child(way) = critnode
                end if
            end if
        end if
        set avlputi = node
    end function

    public function avldeleter(byval data)
        dim done : done = false
        set m_root = avldeleteitemr(m_root, data, done)
        set avldeleter = m_root
    end function

    private function avldeleteitemr(byval node, byval data, byref done)
        if node is nothing then
            done = true
            set avldeleteitemr = node
        elseif node.m_data <> data then
            dim way : way = (node.m_data < data) and 1
            set node.m_child(way) = avldeleteitemr(node.m_child(way), data, done)
            set node = deleteitembal(node, way, done)
            set avldeleteitemr = node
        else ' found it
            if node.m_child(0) is nothing then  ' one child
                set avldeleteitemr = node.m_child(1)
            elseif node.m_child(1) is nothing then  ' one child
                set avldeleteitemr = node.m_child(0)
            else ' 2 children
                dim succ : set succ = node.m_child(1)
                do until succ.m_child(0) is nothing
                    set succ = succ.m_child(0)
                loop
                node.m_data = succ.m_data
                way = 1
                set node.m_child(way) = avldeleteitemr(node.m_child(way), succ.m_data, done)
                set node = deleteitembal(node, way, done)
                set avldeleteitemr = node
            end if
        end if
    end function

    public function avldeletei(byval data)
        dim node, parent, q, way : set node = m_root : set parent = nothing
        dim stack, stknode : set stack = new tstack
        do until node is nothing
            if node.m_data <> data then
                set parent = node
                way = (node.m_data < data) and 1
                set stknode = (new tavlstacknode).init(node, way)
                stack.push stknode
                set node = node.m_child(way)
            else
                if node.m_child(0) is nothing then
                    set q = node.m_child(1)
                    exit do
                elseif node.m_child(1) is nothing then
                    set q = node.m_child(0)
                    exit do
                else
                    dim succ : set succ = node.m_child(1)
                    do until succ.m_child(0) is nothing
                        set succ = succ.m_child(0)
                    loop
                    node.m_data = succ.m_data
                    data = succ.m_data
                    set parent = node
                    way = 1 ' right child
                    set stknode = (new tavlstacknode).init(node, way)
                    stack.push stknode
                    set node = node.m_child(way)
                end if
            end if
        loop
        if node is nothing then ' not found
            set avldeletei = node
            exit function
        end if
        dim done : done = false
        if parent is nothing then
            set m_root = q
            done = true
        else
            set parent.m_child(way) = q
        end if
        do until done   ' update balances up to the root if necessary
            set stknode = stack.pop
            set stknode.m_data = deleteitembal(stknode.m_data, stknode.m_way, done)
            ' notify the parent of possible rotations
            if stack.isempty then
                set m_root = stknode.m_data
                done = true
            else
                dim pstknode : set pstknode = stack.pop
                set pstknode.m_data.m_child(pstknode.m_way) = stknode.m_data
                stack.push pstknode
            end if
        loop
        set avldeletei = node
    end function

    public sub preorderr()
        preorderrnode(m_root)
        wscript.stdout.writeline
    end sub

    private sub preorderrnode(byval node)
        if not node is nothing then
            wscript.stdout.write node.m_data & " "
            preorderrnode(node.m_child(0))
            preorderrnode(node.m_child(1))
        end if
    end sub

    public sub preorderi()
        dim stack : set stack = new tstack
        dim node : set node = m_root
        do until node is nothing and stack.isempty
            if not node is nothing then
                wscript.stdout.write node.m_data & " "
                stack.push node
                set node = node.m_child(0)  ' left child
            else
                set node = stack.pop
                set node = node.m_child(1)  ' right child
            end if
        loop
        wscript.stdout.writeline
    end sub

    public sub inorderr()
        inorderrnode(m_root)
        wscript.stdout.writeline
    end sub

    private sub inorderrnode(byval node)
        if not node is nothing then
            inorderrnode(node.m_child(0))
            wscript.stdout.write node.m_data & " "
            inorderrnode(node.m_child(1))
        end if
    end sub

    public sub inorderi()
        dim stack : set stack = new tstack
        dim node : set node = m_root
        do until node is nothing and stack.isempty
            if not node is nothing then
                stack.push node
                set node = node.m_child(0)  ' left child
            else
                set node = stack.pop
                wscript.stdout.write node.m_data & " "
                set node = node.m_child(1)  ' right child
            end if
        loop
        wscript.stdout.writeline
    end sub

    public sub postorderr()
        postorderrnode(m_root)
        wscript.stdout.writeline
    end sub

    private sub postorderrnode(byval node)
        if not node is nothing then
            postorderrnode(node.m_child(0))
            postorderrnode(node.m_child(1))
            wscript.stdout.write node.m_data & " "
        end if
    end sub

    public sub postorderi()
        dim stack : set stack = new tstack
        dim node, prev : set node = m_root : set prev = nothing
        do until node is nothing and stack.isempty
            if not node is nothing then
                stack.push node
                set node = node.m_child(0)  ' left child
            else
                set node = stack.pop
                if node.m_child(1) is nothing or node.m_child(1) is prev then
                    wscript.stdout.write node.m_data & " "
                    set prev = node
                    set node = nothing
                else
                    stack.push node
                    set node = node.m_child(1)  ' right child
                end if
            end if
        loop
        wscript.stdout.writeline
    end sub

    public sub levelorderi()
        dim queue : set queue = new tqueue
        if not m_root is nothing then
            queue.enqueue m_root
        end if
        do until queue.isempty
            dim node : set node = queue.dequeue
            wscript.stdout.write node.m_data & " "
            if not node.m_child(0) is nothing then
                queue.enqueue node.m_child(0)
            end if
            if not node.m_child(1) is nothing then
                queue.enqueue node.m_child(1)
            end if
        loop
        wscript.stdout.writeline
    end sub

    public function heightr()
        heightr = heightrnode(m_root)
    end function

    private function heightrnode(node)
        if node is nothing then
            heightrnode = 0
        else
            dim lh, rh
            lh = heightrnode(node.m_child(0))
            rh = heightrnode(node.m_child(1))
            heightrnode = 1 + max(lh, rh)
        end if
    end function

    public function heighti()
        dim stack : set stack = new tstack
        dim node, prev : set node = m_root : set prev = nothing
        dim hcnt, hmax : hcnt = 0 : hmax = 0
        do until node is nothing and stack.isempty
            if not node is nothing then
                stack.push node
                hcnt = hcnt+1
                set node = node.m_child(0)  ' left child
            else
                set node = stack.pop
                if node.m_child(1) is nothing or node.m_child(1) is prev then
                    if hcnt > hmax then
                        hmax = hcnt
                    end if
                    hcnt = hcnt-1
                    set prev = node
                    set node = nothing
                else
                    stack.push node
                    set node = node.m_child(1)  ' right child
                end if
            end if
        loop
        heighti = hmax
    end function

    public function heightiq()
        dim queue : set queue = new tqueue
        if not m_root is nothing then
            queue.enqueue m_root
        end if
        dim hcnt, lcnt : hcnt = 0 : lcnt = queue.length
        do until queue.isempty
            dim node : set node = queue.dequeue
            if not node.m_child(0) is nothing then
                queue.enqueue node.m_child(0)   ' left child
            end if
            if not node.m_child(1) is nothing then
                queue.enqueue node.m_child(1)   ' right child
            end if
            lcnt = lcnt-1
            if lcnt = 0 then        ' all done with current level
                hcnt = hcnt+1
                lcnt = queue.length ' set level count to next level size
            end if
        loop
        heightiq = hcnt
    end function

    public sub print()
        dim queue : set queue = new tqueue
        if not m_root is nothing then
            queue.enqueue m_root
        end if
        dim lcnt : lcnt = queue.length  ' set number of nodes at current level
        do until queue.isempty
            dim node : set node = queue.dequeue
            wscript.stdout.write node.m_data & "," & node.m_bal & " "
            if not node.m_child(0) is nothing then
                queue.enqueue node.m_child(0)   ' queue left child
            end if
            if not node.m_child(1) is nothing then
                queue.enqueue node.m_child(1)   ' queue right child
            end if
            lcnt = lcnt-1
            if lcnt = 0 then        ' level is complete
                wscript.stdout.writeline
                lcnt = queue.length ' reset level count to number of nodes in next level
            end if
        loop
        wscript.stdout.writeline
    end sub

end class

call main()
