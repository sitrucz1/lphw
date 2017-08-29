option explicit

sub main()
    includefile "queue.vbs"     ' tqueue and tstack
    dim tree : set tree = new tavl
    tree.avlputi(3)
    tree.avlputi(2)
    tree.avlputi(1)
    tree.preorderi
    wscript.echo tree.isavl
    set tree.m_root = tree.rotate(tree.m_root, 1)
    tree.preorderi
    wscript.echo tree.isavl
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
    tree.levelorderi
    tree.avldeleter(2)
    tree.levelorderi
    tree.avldeleter(5)
    tree.levelorderi
    wscript.echo tree.isavl
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

    public function isavl()
        isavl = (isavlnode(m_root) <> -1)
    end function

    private function isavlnode(byval node)
        if node is nothing then
            isavlnode = 0
        elseif isless(node, node.m_child(0)) or isless(node.m_child(1), node) then
            wscript.echo "ERROR: not a BST"
            isavlnode = -1
        elseif node.m_bal < -1 or node.m_bal > 1 then
            wscript.echo "ERROR: node balance is out of range"
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
        set m_root = avlputitemr(m_root, data)
        set avlputr = m_root
    end function

    private function avlputitemr(byval node, byval data)
        if node is nothing then
            set node = (new tavlnode).init(data)
            set avlputitemr = node
        elseif node.m_data = data then
            set avlputitemr = node
        else
            dim way : way = (node.m_data < data) and 1
            set node.m_child(way) = avlputitemr(node.m_child(way), data)
            set avlputitemr = node
        end if
    end function

    public function avlputi(byval data)
        dim node, parent, way : set node = m_root : set parent = nothing
        do until node is nothing
            if node.m_data = data then
                set avlputi = node
                exit function
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
        end if
        set avlputi = node
    end function

    public function avldeleter(byval data)
        set m_root = avldeleteitemr(m_root, data)
        set avldeleter = m_root
    end function

    private function avldeleteitemr(byval node, byval data)
        if node is nothing then
            set avldeleteitemr = node
        elseif node.m_data <> data then
            dim way : way = (node.m_data < data) and 1
            set node.m_child(way) = avldeleteitemr(node.m_child(way), data)
            set avldeleteitemr = node
        else ' found it
            if node.m_child(0) is nothing then  ' one child
                set avldeleteitemr = node.m_child(1)
            elseif node.m_child(1) is nothing then  ' one child
                set avldeleteitemr = node.m_child(0)
            else ' 2 children
                dim succ : set succ = node.m_child(1)
                do until succ.m_child(0) is nothing
                    set succ = succ.m_next(0)
                loop
                node.m_data = succ.m_data
                set node.m_child(1) = avldeleteitemr(node.m_child(1), succ.m_data)
                set avldeleteitemr = node
            end if
        end if
    end function

    public function avldeletei(byval data)
        dim node, parent, q, way : set node = m_root : set parent = nothing
        do until node is nothing
            if node.m_data <> data then
                set parent = node
                way = (node.m_data < data) and 1
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
                        set succ = succ.m_next(0)
                    loop
                    node.m_data = succ.m_data
                    data = succ.m_data
                    set parent = node
                    way = 1 ' right child
                    set node = node.m_child(way)
                end if
            end if
        loop
        if node is nothing then ' not found
            set avldeletei = node
            exit function
        end if
        if parent is nothing then
            set m_root = q
        else
            set parent.m_child(way) = q
        end if
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

end class

call main()
