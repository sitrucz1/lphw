option explicit

const red = true
const black = false

sub main()
    includefile "queue.vbs"     ' tqueue and tstack
    dim i, arr : arr = array(5,3,4,7,1,9,11,13,15,2)
    dim tree : set tree = new trbtree
    randomize timer
    ' for i=1 to 20
    for i = 0 to ubound(arr)
        tree.rbputi(arr(i))
        ' tree.rbputi(cint(rnd*1000))
        ' tree.print
        ' if not tree.isrbtree then
        '     exit for
        ' end if
    next
    tree.print
    tree.isrbtree
    wscript.stdout.write "Press enter to continue..."
    wscript.stdin.read(1)
    do until tree.isempty or not tree.isrbtree
        tree.rbdeletei(tree.m_root.m_data)
        tree.print
    loop
end sub

sub includefile(fspec)
    executeglobal createobject("scripting.filesystemobject").opentextfile(fspec).readall()
end sub

class trbnode

    public m_data
    public m_child(1) '0-left, 1-right
    public m_color

    public function init(byval data)
        m_data = data
        set m_child(0) = nothing
        set m_child(1) = nothing
        m_color = red
        set init = me
    end function

end class

class trbtree

    public m_root
    public m_cnt

    private sub class_initialize()
        set m_root = nothing
        m_cnt = 0
    end sub

    private function iif(byval condition, byval a, byval b)
        if condition then
            iif = a
        else
            iif = b
        end if
    end function

    private function isless(byval a, byval b)
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

    private function isred(byval node)
        if node is nothing then
            isred = false
        else
            isred = (node.m_color = red)
        end if
    end function

    private function color2char(byval node)
        if node is nothing then
            color2char = "b"
        elseif isred(node) then
            color2char = "r"
        else
            color2char = "b"
        end if
    end function

    public function isempty
        isempty = (m_root is nothing)
    end function

    public function isrbtree()
        isrbtree = (isrbnode(m_root) <> -1)
    end function

    private function isrbnode(node)
        if node is nothing then
            isrbnode = 0
        elseif node is m_root and isred(node) then
            wscript.echo "ERROR: root is red", node.m_data
            isrbnode = -1
        elseif isless(node, node.m_child(0)) or isless(node.m_child(1), node) then
            wscript.echo "ERROR: not a BST", node.m_data
            isrbnode = -1
        elseif isred(node) and (isred(node.m_child(0)) or isred(node.m_child(1))) then
            wscript.echo "ERROR: two red nodes in a row", node.m_data
            isrbnode = -1
        else
            dim lh, rh
            lh = isrbnode(node.m_child(0))
            rh = isrbnode(node.m_child(1))
            if lh = -1 or rh = -1 then
                isrbnode = -1
            elseif lh <> rh then
                wscript.echo "ERROR: black heights don't match", node.m_data
                isrbnode = -1
            elseif isred(node) then
                isrbnode = lh
            else ' black node
                isrbnode = lh+1
            end if
        end if
    end function

    public sub print()
        dim queue : set queue = new tqueue
        if m_root is nothing then
            exit sub
        end if
        queue.enqueue m_root
        dim lcnt : lcnt = queue.length
        do until queue.isempty
            dim node : set node = queue.dequeue
            wscript.stdout.write node.m_data & "," & color2char(node) & " "
            if not node.m_child(0) is nothing then
                queue.enqueue node.m_child(0)   ' left child
            end if
            if not node.m_child(1) is nothing then
                queue.enqueue node.m_child(1)   ' right child
            end if
            lcnt = lcnt-1
            if lcnt = 0 then        ' all done with current level
                wscript.stdout.writeline
                lcnt = queue.length ' set level count to next level size
            end if
        loop
        wscript.stdout.writeline
    end sub

    public function rbfindi(data)
        dim node : set node = m_root
        do until node is nothing
            if node.m_data = data then
                exit do
            end if
            dim way : way = (node.m_data < data) and 1
            set node = node.m_child(way)
        loop
        set rbfindi = node
    end function

    public function rotate(byval node, byval way)
        dim root : set root = node.m_child(way xor 1)
        set node.m_child(way xor 1) = root.m_child(way)
        set root.m_child(way) = node
        root.m_color = node.m_color
        node.m_color = red
        set rotate = root
    end function

    private sub colorflip(byval node)
        node.m_color = not node.m_color
        node.m_child(0).m_color = not node.m_color
        node.m_child(1).m_color = not node.m_color
    end sub

    public function makefakehead
        dim node : set node = (new trbnode).init(0)
        node.m_color = black
        set node.m_child(1) = m_root
        set makefakehead = node
    end function

    public function rbputi(byval data)
        wscript.echo "Insert", data
        dim node, k, na(50), wa(50) ' stack
        k = 0 : set na(k) = makefakehead : wa(k) = 1 ' push fake head
        set node = m_root
        do until node is nothing
            if node.m_data = data then
                set rbputi = node
                exit function
            end if
            k = k+1 : set na(k) = node : wa(k) = (node.m_data < data) and 1 ' push node
            set node = node.m_child(wa(k))
        loop
        ' create the node
        set node = (new trbnode).init(data)
        if node is nothing then
            wscript.stdout.writeline "node could not be allocated."
            rbputi = node
            exit function
        end if
        ' update the tree
        k = k+1
        set na(k-1).m_child(wa(k-1)) = node
        ' fixup
        do while isred(na(k-1))
            if isred(na(k-2).m_child(wa(k-2) xor 1)) then
                wscript.echo "Case 1 - Color Flip", na(k-2).m_data
                colorflip na(k-2)
                k = k-2
            else
                if isred(na(k-1).m_child(wa(k-2) xor 1)) then         ' case 2 - rotate l/r or r/l
                    wscript.echo "Case 2 - Rotate", na(k-1).m_data, wa(k-2)
                    set na(k-1) = rotate(na(k-1), wa(k-2))
                    set na(k-2).m_child(wa(k-2)) = na(k-1)
                end if
                wscript.echo "Case 3 - Rotate", na(k-2).m_data, wa(k-2) xor 1
                set na(k-2) = rotate(na(k-2), wa(k-2) xor 1)          ' case 3 - rotate ll or rr
                set na(k-3).m_child(wa(k-3)) = na(k-2)
                k = 1
            end if
        loop
        ' update root and counts
        set m_root = na(0).m_child(1)
        m_root.m_color = black
        m_cnt = m_cnt+1
        set rbputi = node
    end function

    private sub rbputifixup(byval node)
        do while isred(node.m_parent)
            dim way : way = (node.m_parent.m_parent.m_child(1) is node.m_parent) and 1
            if isred(node.m_parent.m_parent.m_child(way xor 1)) then    ' case 1 - color flip
                wscript.echo "Case 1 - Color Flip", node.m_parent.m_parent.m_data
                colorflip node.m_parent.m_parent
                set node = node.m_parent.m_parent
            else
                if isred(node.m_parent.m_child(way xor 1)) then         ' case 2 - rotate l/r or r/l
                    set node = node.m_parent
                    wscript.echo "Case 2 - Rotate", node.m_data, way
                    rotate node, way
                end if
                wscript.echo "Case 3 - Rotate", node.m_parent.m_parent.m_data, way xor 1
                rotate node.m_parent.m_parent, way xor 1                ' case 3 - rotate ll or rr
            end if
        loop
        m_root.m_color = black
    end sub

    public function rbdeletei(byval data)
        wscript.echo "Deleting => ", data
        dim node, x, k, na(50), wa(50) ' stack
        x = 0 ' found node
        k = 0 : set na(k) = makefakehead : wa(k) = 1 ' push fake head
        set node = m_root
        do until node is nothing
            k = k+1 : set na(k) = node : wa(k) = (node.m_data <= data) and 1 ' push node
            if wa(k) = 1 then
                x = k ' critical node
            end if
            set node = node.m_child(wa(k))
        loop
        if x = 0 or na(x).m_data <> data then ' not found
            set rbdeletei = node
            exit function
        end if
        ' return value
        set node = na(k) ' deleted node
        ' splice out node
        na(x).m_data = na(k).m_data
        set na(k) = na(k).m_child(wa(k) xor 1)
        set na(k-1).m_child(wa(k-1)) = na(k)
        dim saved_color : saved_color = na(k).m_color
        if not na(k) is nothing then
            na(k).m_color = black
        end if
        ' fixup
        if saved_color = black then
            do until k < 2 or isred(na(k))
                dim way : way = wa(k-1)
                dim sib : set sib = na(k-1).m_child(way xor 1)
                if isred(sib) then                                              ' case 1 - red sibling case reduction
                    wscript.echo "case 1 - red sibling case reduction - rotate", na(k-1).m_data, way
                    set na(k-1) = rotate(na(k-1), way)
                    set na(k-2).m_child(wa(k-2)) = na(k-1)
                    set na(k) = na(k-1).m_child(way)
                    k = k+1
                    set sib = na(k-1).m_child(way xor 1)
                end if
                if not isred(sib.m_child(0)) and not isred(sib.m_child(1)) then ' case 2 - black sibling and black children - recolor sibling push problem up the tree
                    wscript.echo "case 2 - black sibling and black children - recolor sibling and push problem up the tree", na(k-1).m_data, way
                    sib.m_color = red
                    k = k-1
                else
                    ' cjm begin here
                    if not isred(sib.m_child(way xor 1)) then                   ' case 3 - lr/rl sibling red child - rotate
                        wscript.echo "case 3 - lr/rl sibling red child - rotate", sib.m_data, way xor 1
                        rotate sib, way xor 1
                        ' set sib = node.m_parent.m_child(way xor 1)
                    end if
                    wscript.echo "case 4 - ll/rr sibling red child - rotate", node.m_parent.m_data, way
                    rotate node.m_parent, way                                   ' case 4 - ll/rr sibling red child - rotate
                    node.m_parent.m_color = black
                    node.m_parent.m_parent.m_child(way xor 1).m_color = black
                    set node = m_root
                end if
            loop
            node.m_color = black
        end if
        ' update root and counts
        set m_root = na(0).m_child(1)
        m_cnt = m_cnt-1
        set rbdeletei = node
    end function

    private sub rbdeleteifixup(byval node)
        do until node is m_root or isred(node)
            dim way : way = (node is node.m_parent.m_child(1)) and 1
            dim sib : set sib = node.m_parent.m_child(way xor 1)
            if isred(sib) then                                              ' case 1 - red sibling case reduction
                wscript.echo "case 1 - red sibling case reduction - rotate", node.m_parent.m_data, way
                rotate node.m_parent, way
                set sib = node.m_parent.m_child(way xor 1)
            end if
            if not isred(sib.m_child(0)) and not isred(sib.m_child(1)) then ' case 2 - black sibling and black children - recolor sibling push problem up the tree
                wscript.echo "case 2 - black sibling and black children - recolor sibling and push problem up the tree", node.m_parent.m_data, way
                sib.m_color = red
                set node = node.m_parent
            else
                if not isred(sib.m_child(way xor 1)) then                   ' case 3 - lr/rl sibling red child - rotate
                    wscript.echo "case 3 - lr/rl sibling red child - rotate", sib.m_data, way xor 1
                    rotate sib, way xor 1
                    ' set sib = node.m_parent.m_child(way xor 1)
                end if
                wscript.echo "case 4 - ll/rr sibling red child - rotate", node.m_parent.m_data, way
                rotate node.m_parent, way                                   ' case 4 - ll/rr sibling red child - rotate
                node.m_parent.m_color = black
                node.m_parent.m_parent.m_child(way xor 1).m_color = black
                set node = m_root
            end if
        loop
        node.m_color = black
    end sub

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

    public sub preorderiw()
        dim stack : set stack = new tstack
        dim node : set node = m_root
        do while true
            do until node is nothing
                wscript.stdout.write node.m_data & " "
                stack.push node
                set node = node.m_child(0)  ' left child
            loop
            if not stack.isempty then
                set node = stack.pop
                set node = node.m_child(1)
            else
                exit do
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

    public sub inorderiw()
        dim stack : set stack = new tstack
        dim node : set node = m_root
        do while true
            do until node is nothing
                stack.push node
                set node = node.m_child(0)  ' left child
            loop
            if not stack.isempty then
                set node = stack.pop
                wscript.stdout.write node.m_data & " "
                set node = node.m_child(1)
            else
                exit do
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

    public sub postorderiw()
        dim stack : set stack = new tstack
        dim node, prev : set node = m_root : set prev = nothing
        do while true
            do until node is nothing
                stack.push node
                set node = node.m_child(0)  ' left child
            loop
            if not stack.isempty then
                set node = stack.pop
                if node.m_child(1) is nothing or node.m_child(1) is prev then
                    wscript.stdout.write node.m_data & " "
                    set prev = node
                    set node = nothing
                else
                    stack.push node
                    set node = node.m_child(1)
                end if
            else
                exit do
            end if
        loop
        wscript.stdout.writeline
    end sub

    public sub levelorderi()
        dim queue : set queue = new tqueue
        if m_root is nothing then
            exit sub
        end if
        queue.enqueue m_root
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
        if m_root is nothing then
            heightiq = 0
            exit function
        end if
        queue.enqueue m_root
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

end class

call main()
