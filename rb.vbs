option explicit

const red = true
const black = false

sub main()
    includefile "queue.vbs"     ' tqueue and tstack
    dim i, arr : arr = array(5,3,7,1,4,9,11,13,15,2)
    dim tree : set tree = new trbtree
    randomize timer
    ' for i=1 to 5
    '     tree.rbputi(cint(rnd*100))
        ' tree.print
        ' if not tree.isrbtree then
        '     exit for
        ' end if
    ' next
    tree.rbputi(71)
    tree.rbputi(32)
    tree.rbputi(95)
    tree.rbputi(23)
    tree.rbputi(100)
    tree.print
    tree.isrbtree
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
    public m_child(2) ' 0-left, 1-right, 2-parent
    public m_color

    public function init(byval data)
        m_data = data
        set m_child(0) = nothing
        set m_child(1) = nothing
        set m_child(2) = nothing
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
            color2char = ""
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
        if not root.m_child(way) is nothing then
            set root.m_child(way).m_child(2) = node
        end if
        set root.m_child(2) = node.m_child(2)
        if node.m_child(2) is nothing then
            set m_root = root
        else
            dim wayp : wayp = (node is node.m_child(2).m_child(1)) and 1
            set node.m_child(2).m_child(wayp) = root
        end if
        set root.m_child(way) = node
        set node.m_child(2) = root
        root.m_color = node.m_color
        node.m_color = red
        set rotate = root
    end function

    private sub colorflip(byval node)
        node.m_color = not node.m_color
        node.m_child(0).m_color = not node.m_color
        node.m_child(1).m_color = not node.m_color
    end sub

    public function rbputi(byval data)
        wscript.echo "Insert", data
        dim node, parent, way : set node = m_root : set parent = nothing
        do until node is nothing
            if node.m_data = data then
                set rbputi = node
                exit function
            end if
            set parent = node
            way = (node.m_data < data) and 1
            set node = node.m_child(way)
        loop
        ' create the node
        set node = (new trbnode).init(data)
        if node is nothing then
            wscript.stdout.writeline "node could not be allocated."
            rbputi = node
            exit function
        end if
        dim inserted : set inserted = node ' save a pointer to inserted node
        ' update the tree
        set node.m_child(2) = parent
        if parent is nothing then
            set m_root = node
        else
            set parent.m_child(way) = node
        end if
        ' rebalance
        do while isred(parent)
            dim gparent : set gparent = parent.m_child(2)
            way = (gparent.m_child(1) is parent) and 1
            if isred(gparent.m_child(way xor 1)) then    ' case 1 - color flip
                wscript.echo "Case 1 - Color Flip", gparent.m_data
                colorflip gparent
                set node = gparent
                set parent = gparent.m_child(2)
            else
                if isred(parent.m_child(way xor 1)) then ' case 2 - rotate l/r or r/l
                    wscript.echo "Case 2 - Rotate", gparent.m_child(way).m_data, way
                    set gparent.m_child(way) = rotate(gparent.m_child(way), way)
                end if
                wscript.echo "Case 3 - Rotate", gparent.m_data, way xor 1
                set gparent = rotate(gparent, way xor 1) ' case 3 - rotate ll or rr
                exit do
            end if
        loop
        m_root.m_color = black
        set rbputi = inserted
    end function

    public function rbdeletei(byval data)
        wscript.echo "Deleting => ", data
        dim node, parent, q, way : set node = m_root : set parent = nothing
        do until node is nothing ' or node.m_data = data
            if node.m_data = data then
                exit do
            end if
            set parent = node
            way = (node.m_data < data) and 1
            set node = node.m_child(way)
        loop
        if node is nothing then ' not found
            set rbdeletei = node
            exit function
        end if
        if node.m_child(0) is nothing then
            set q = node.m_child(1)
        elseif node.m_child(1) is nothing then
            set q = node.m_child(0)
        else
            dim succ : set succ = node.m_child(1)
            do until succ.m_child(0) is nothing
                set succ = succ.m_child(0)
            loop
            node.m_data = succ.m_data
            set node = succ
            set q = node.m_child(1)
        end if
        if not node is m_root and not isred(node) and not isred(q) then
            ' rebalance
            dim db : set db = node
            do
                way = (db is db.m_child(2).m_child(1)) and 1
                dim sib : set sib = db.m_child(2).m_child(way xor 1)
                if isred(sib) then                                              ' case 1 - red sibling case reduction
                    wscript.echo "case 1 - red sibling case reduction"
                    set db.m_child(2) = rotate(db.m_child(2), way xor 1)
                    set sib = db.m_child(2).m_child(way xor 1)
                end if
                if not isred(sib.m_child(0)) and not isred(sib.m_child(1)) then ' case 2 - black sibling and black children - recolor sibling push problem up the tree
                    wscript.echo "case 2 - black sibling and black children - recolor sibling and push problem up the tree"
                    sib.m_color = red
                    if isred(db.m_child(2)) or db.m_child(2) is root then
                        db.m_child(2).m_color = black
                        exit do
                    end if
                    set db = db.m_child(2)
                else
                    if isred(sib.m_child(way)) then                             ' case 3 - lr/rl sibling red child - rotate
                        wscript.echo "case 3 - lr/rl sibling red child - rotate"
                        set db.m_child(2).m_child(way xor 1) = rotate(db.m_child(2).m_child(way xor 1), way xor 1)
                    end if
                    wscript.echo "case 4 - ll/rr sibling red child - rotate"
                    set db.m_child(2) = rotate(db.m_child(2), way)              ' case 4 - ll/rr sibling red child - rotate
                    db.m_child(2).m_child(0).m_color = black
                    db.m_child(2).m_child(1).m_color = black
                    exit do
                end if
            loop until false 
        end if
        if node.m_child(2) is nothing then
            set m_root = q
        else
            way = (node is node.m_child(2).m_child(1)) and 1
            set node.m_child(2).m_child(way) = q
        end if
        if not q is nothing then
            set q.m_child(2) = node.m_child(2)
            q.m_color = black
        end if
        if not m_root is nothing then
            m_root.m_color = black
        end if
        set rbdeletei = node
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

end class

call main()
