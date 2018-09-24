option explicit

const red = true
const black = false

sub main()
    includefile "queue.vbs"     ' tqueue and tstack
    dim i, arr : arr = array(5,3,4,7,1,9,11,13,15,2)
    ' dim i, arr : arr = array(3,5)
    dim tree : set tree = new trbtree
    randomize timer
    for i=1 to 30
    ' for i = 0 to ubound(arr)
        ' tree.rbput(arr(i))
        tree.rbput(cint(rnd*100))
        ' tree.print
        if not tree.isrbtree then
            exit for
        end if
    next
    tree.print
    tree.printbtree
    tree.isrbtree
    wscript.stdout.write "Press enter to continue..."
    wscript.stdin.readline
    ' wscript.echo tree.rbget(1).m_key
    ' wscript.stdout.write "Press enter to continue..."
    ' wscript.stdin.readline
    ' tree.printbtree
    ' tree.isrbtree
    do until tree.isempty or not tree.isrbtree
        tree.rbdeletemin
        tree.printbtree
    loop
end sub

sub includefile(fspec)
    executeglobal createobject("scripting.filesystemobject").opentextfile(fspec).readall()
end sub

class trbnode

    public m_key
    public m_left
    public m_right
    public m_color

    public function init(byval key)
        m_key = key
        set m_left = nothing
        set m_right = nothing
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
            isless = (a.m_key < b.m_key)
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

    private function isrbnode(byval node)
        if node is nothing then
            isrbnode = 0
        elseif node is m_root and isred(node) then
            wscript.echo "ERROR: root is red", node.m_key
            isrbnode = -1
        elseif isless(node, node.m_left) or isless(node.m_right, node) then
            wscript.echo "ERROR: not a BST", node.m_key
            isrbnode = -1
        elseif not isred(node.m_left) and isred(node.m_right) then
            wscript.echo "ERROR: right node is not left leaning", node.m_key
            isrbnode = -1
        elseif isred(node) and (isred(node.m_left) or isred(node.m_right)) then
            wscript.echo "ERROR: two red nodes in a row", node.m_key
            isrbnode = -1
        else
            dim lh, rh
            lh = isrbnode(node.m_left)
            rh = isrbnode(node.m_right)
            if lh = -1 or rh = -1 then
                isrbnode = -1
            elseif lh <> rh then
                wscript.echo "ERROR: black heights don't match", node.m_key
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
            wscript.stdout.write node.m_key & "," & color2char(node) & " "
            if not node.m_left is nothing then
                queue.enqueue node.m_left   ' left child
            end if
            if not node.m_right is nothing then
                queue.enqueue node.m_right   ' right child
            end if
            lcnt = lcnt-1
            if lcnt = 0 then        ' all done with current level
                wscript.stdout.writeline
                lcnt = queue.length ' set level count to next level size
            end if
        loop
        wscript.stdout.writeline
    end sub

    public sub printbtree()
        dim queue : set queue = new tqueue
        if m_root is nothing then
            exit sub
        end if
        queue.enqueue m_root
        do until queue.isempty
            dim lcnt : lcnt = queue.length
            do while lcnt > 0
                dim node : set node = queue.dequeue
                if isred(node.m_left) then ' red node
                    dim lc : set lc = node.m_left
                    wscript.stdout.write lc.m_key
                    if not lc.m_left is nothing then
                        queue.enqueue lc.m_left     ' left left child
                    end if
                    if not lc.m_right is nothing then
                        queue.enqueue lc.m_right    ' left right child
                    end if
                else                        ' black node
                    wscript.stdout.write "*"
                    if not node.m_left is nothing then
                        queue.enqueue node.m_left   ' left child
                    end if
                end if
                wscript.stdout.write "," & node.m_key
                if isred(node.m_right) then ' red node
                    dim rc : set rc = node.m_right
                    wscript.stdout.write "," & rc.m_key
                    if not rc.m_left is nothing then
                        queue.enqueue rc.m_left     ' right left child
                    end if
                    if not rc.m_right is nothing then
                        queue.enqueue rc.m_right    ' right right child
                    end if
                else                        ' black node
                    wscript.stdout.write ",*"
                    if not node.m_right is nothing then
                        queue.enqueue node.m_right   ' right child
                    end if
                end if
                wscript.stdout.write "  "
                lcnt = lcnt-1
            loop
            wscript.stdout.writeline
        loop
        wscript.stdout.writeline
    end sub

    public function rbget(byval key)
        set rbget = rbgetn(m_root, key)
    end function

    public function rbgetn(byval node, byval key)
        if node is nothing then
            set node = nothing
        else
            if key < node.m_key then
                set node = rbgetn(node.m_left, key)
            elseif key > node.m_key then
                set node = rbgetn(node.m_right, key)
            else
                set node = node
            end if
        end if
        set rbgetn = node
    end function

    public function rotateleft(byval node)
        wscript.echo "Rotate Left.", node.m_key
        dim root : set root = node.m_right
        set node.m_right = root.m_left
        set root.m_left = node
        root.m_color = node.m_color
        node.m_color = red
        set rotateleft = root
    end function

    public function rotateright(byval node)
        wscript.echo "Rotate Right.", node.m_key
        dim root : set root = node.m_left
        set node.m_left = root.m_right
        set root.m_right = node
        root.m_color = node.m_color
        node.m_color = red
        set rotateright = root
    end function

    private sub colorflip(byval node)
        wscript.echo "Color Flip", node.m_key
        node.m_color = not node.m_color
        node.m_left.m_color = not node.m_color
        node.m_right.m_color = not node.m_color
    end sub

    public function rbbalance(byval node)
        if isred(node.m_right) then
            set node = rotateleft(node)
        end if
        if isred(node.m_left) then
            if isred(node.m_left.m_left) then
                set node = rotateright(node)
            end if
        end if
        set rbbalance = node
    end function

    public function rbput(byval key)
        wscript.echo "** Inserting => ", key
        set m_root = rbputn(m_root, key)
        m_root.m_color = black
        set rbput = m_root
    end function

    public function rbputn(byval node, byval key)
        if node is nothing then
            set node = (new trbnode).init(key)
            m_cnt = m_cnt+1
        else
            if isred(node.m_left) and isred(node.m_right) then
                colorflip node
            end if

            if key < node.m_key then
                set node.m_left = rbputn(node.m_left, key)
            elseif key > node.m_key then
                set node.m_right = rbputn(node.m_right, key)
            else
                node.m_key = key
            end if

            if isred(node.m_right) then
                set node = rotateleft(node)
            end if
            if isred(node.m_left) then
                if isred(node.m_left.m_left) then
                    set node = rotateright(node)
                end if
            end if
        end if
        set rbputn = node
    end function

    public function moveredleft(byval node)
        ' assert: not node is nothing
        ' assert: isred(node) and not isred(node.m_left)
        wscript.echo "Move Red Left.", node.m_key
        colorflip node
        if isred(node.m_right.m_left) then
            set node.m_right = rotateright(node.m_right)
            set node = rotateleft(node)
            colorflip node
        end if
        if isred(node.m_right.m_right) then
            set node.m_right = rotateleft(node.m_right)
        end if
        set moveredleft = node
    end function

    public function moveredright(byval node)
        ' assert: not node is nothing
        ' assert: isred(node) and not isred(node.m_right) and not isred(node.m_right.m_left)
        wscript.echo "Move Red Right.", node.m_key
        colorflip node
        if isred(node.m_left.m_right) then
            set node.m_left = rotateleft(node.m_left)
            set node = rotateright(node)
            colorflip node
        elseif isred(node.m_left.m_left) then
            set node = rotateright(node)
            colorflip node
        end if
        ' if not isred(node.m_left.m_left) and isred(node.m_left.m_right) then
        '     set node.m_left = rotateleft(node.m_left)
        ' end if
        set moveredright = node
    end function

    public function rbdeletemax()
        wscript.echo "** Deleting max."
        if not m_root is nothing then
            if not isred(m_root.m_left) and not isred(m_root.m_right) then
                m_root.m_color = red
            end if
        end if
        set m_root = rbdeletemaxn(m_root)
        if not isempty then
            m_root.m_color = black
        end if
        set rbdeletemax = nothing
    end function

    public function rbdeletemaxn(byval node)
        if not isred(node.m_right) and isred(node.m_left) then
            set node = rotateright(node)
        end if
        ' Are we at the max node?
        if node.m_right is nothing then
            m_cnt = m_cnt-1
            set node = nothing
        else
            if not isred(node.m_right) and not isred(node.m_right.m_left) then
                set node = moveredright(node)
            end if
            set node.m_right = rbdeletemaxn(node.m_right)
        end if
        if not node is nothing then
            set node = rbbalance(node)
        end if
        set rbdeletemaxn = node
    end function

    public function rbdeletemin()
        wscript.echo "** Deleting min."
        if not m_root is nothing then
            if not isred(m_root.m_left) and not isred(m_root.m_right) then
                m_root.m_color = red
            end if
        end if
        set m_root = rbdeleteminn(m_root)
        if not isempty then
            m_root.m_color = black
        end if
        set rbdeletemin = nothing
    end function

    public function rbdeleteminn(byval node)
        if node.m_left is nothing then
            m_cnt = m_cnt-1
            set node = nothing
        else
            if not isred(node.m_left) and not isred(node.m_left.m_left) then
                set node = moveredleft(node)
            end if
            set node.m_left = rbdeleteminn(node.m_left)
        end if
        if not node is nothing then
            set node = rbbalance(node)
        end if
        set rbdeleteminn = node
    end function

    public function rbdelete(byval key)
        wscript.echo "** Deleting => ", key
        if not rbget(key) is nothing then
            if not isred(m_root.m_left) and not isred(m_root.m_right) then
                m_root.m_color = red
            end if
            set m_root = rbdeleten(m_root, key)
            if not isempty then
                m_root.m_color = black
            end if
        end if
        set rbdelete = nothing
    end function

    public function rbdeleten(byval node, byval key)
        if key < node.m_key then
            if not isred(node.m_left) then
                if not isred(node.m_left.m_left) then
                    set node = moveredleft(node)
                end if
            end if
            set node.m_left = rbdeleten(node.m_left, key)
        else
            if not isred(node.m_right) and isred(node.m_left) then
                set node = rotateright(node)
            end if
            if key = node.m_key and node.m_right is nothing then
                m_cnt = m_cnt-1
                set node = nothing
            else
                if not isred(node.m_right) then
                    if not isred(node.m_right.m_left) then
                        set node = moveredright(node)
                    end if
                end if
                if (key = node.m_key) then
                    dim s : set s = node.m_right
                    do until s.m_left is nothing
                        set s = s.m_left
                    loop
                    node.m_key = s.m_key
                    set node.m_right = rbdeletemin(node.m_right)
                else
                    set node.m_right = rbdeleten(node.m_right, key)
                end if
            end if
        end if
        if not node is nothing then
            set node = rbbalance(node)
        end if
        set rbdeleten = node
    end function

    public sub preorderr()
        preorderrnode(m_root)
        wscript.stdout.writeline
    end sub

    private sub preorderrnode(byval node)
        if not node is nothing then
            wscript.stdout.write node.m_key & " "
            preorderrnode(node.m_left)
            preorderrnode(node.m_right)
        end if
    end sub

    public sub inorderr()
        inorderrnode(m_root)
        wscript.stdout.writeline
    end sub

    private sub inorderrnode(byval node)
        if not node is nothing then
            inorderrnode(node.m_left)
            wscript.stdout.write node.m_key & " "
            inorderrnode(node.m_right)
        end if
    end sub

    public sub postorderr()
        postorderrnode(m_root)
        wscript.stdout.writeline
    end sub

    private sub postorderrnode(byval node)
        if not node is nothing then
            postorderrnode(node.m_left)
            postorderrnode(node.m_right)
            wscript.stdout.write node.m_key & " "
        end if
    end sub

    public sub levelorderi()
        dim queue : set queue = new tqueue
        if m_root is nothing then
            exit sub
        end if
        queue.enqueue m_root
        do until queue.isempty
            dim node : set node = queue.dequeue
            wscript.stdout.write node.m_key & " "
            if not node.m_left is nothing then
                queue.enqueue node.m_left
            end if
            if not node.m_right is nothing then
                queue.enqueue node.m_right
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
            lh = heightrnode(node.m_left)
            rh = heightrnode(node.m_right)
            heightrnode = 1 + max(lh, rh)
        end if
    end function

end class

call main()
