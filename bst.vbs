option explicit

sub main()
    includefile "queue.vbs"     ' tqueue and tstack
    dim tree : set tree = new tbst
    set tree.m_root = (new tbstnode).init(5)
    set tree.m_root.m_child(0) = (new tbstnode).init(3)
    set tree.m_root.m_child(0).m_child(0) = (new tbstnode).init(1)
    set tree.m_root.m_child(0).m_child(1) = (new tbstnode).init(4)
    set tree.m_root.m_child(0).m_child(0).m_child(1) = (new tbstnode).init(2)
    set tree.m_root.m_child(1) = (new tbstnode).init(7)
    set tree.m_root.m_child(1).m_child(1) = (new tbstnode).init(10)
    set tree.m_root.m_child(1).m_child(1).m_child(1) = (new tbstnode).init(15)
    set tree.m_root.m_child(1).m_child(1).m_child(0) = (new tbstnode).init(8)
    set tree.m_root.m_child(1).m_child(1).m_child(0).m_child(1) = (new tbstnode).init(9)
    set tree.m_root.m_child(1).m_child(1).m_child(1).m_child(1) = (new tbstnode).init(18)
    set tree.m_root.m_child(1).m_child(1).m_child(1).m_child(1).m_child(1) = (new tbstnode).init(19)
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
    tree.preorderiw
    tree.inorderr
    tree.inorderi
    tree.inorderiw
    tree.postorderr
    tree.postorderi
    tree.postorderiw
    tree.levelorderi
    wscript.echo tree.heightr
    wscript.echo tree.heighti
    wscript.echo tree.heightiq
    wscript.echo tree.isbst(tree.m_root)
    if tree.bstfindr(7) is nothing then
        wscript.echo "not found"
    else
        wscript.echo "found"
    end if
    if tree.bstfindr(2) is nothing then
        wscript.echo "not found"
    else
        wscript.echo "found"
    end if
    if tree.bstfindr(6) is nothing then
        wscript.echo "not found"
    else
        wscript.echo "found"
    end if
    if tree.bstfindi(2) is nothing then
        wscript.echo "not found"
    else
        wscript.echo "found"
    end if
    set tree = nothing
    set tree = new tbst
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
    set tree = new tbst
    tree.bstputi(5)
    tree.bstputi(4)
    tree.bstputi(1)
    tree.bstputi(2)
    tree.bstputi(7)
    tree.levelorderi
    wscript.echo tree.isbst(tree.m_root)
    tree.bstdeletei(1)
    tree.levelorderi
    tree.bstdeletei(5)
    tree.levelorderi
    wscript.echo tree.isbst(tree.m_root)
end sub

sub includefile(fspec)
    executeglobal createobject("scripting.filesystemobject").opentextfile(fspec).readall()
end sub

class tbstnode

    public m_data
    public m_child(1)

    public function init(byval data)
        m_data = data
        set m_child(0) = nothing
        set m_child(1) = nothing
        set init = me
    end function

end class

class tbst

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

    public function isbst(node)
        if node is nothing then
            isbst = true
        elseif isless(node, node.m_child(0)) or isless(node.m_child(1), node) then
            wscript.echo "ERROR: not a BST"
            isbst = false
        else
            isbst = isbst(node.m_child(0)) and isbst(node.m_child(1))
        end if
    end function

    public function bstfindr(data)
        set bstfindr = bstfindnoder(m_root, data)
    end function

    private function bstfindnoder(byval node, byval data)
        if node is nothing then
            set bstfindnoder = node
        elseif node.m_data = data then
            set bstfindnoder = node
        else
            dim way : way = (node.m_data < data) and 1
            set bstfindnoder = bstfindnoder(node.m_child(way), data)
        end if
    end function

    public function bstfindi(data)
        dim node : set node = m_root
        do until node is nothing
            if node.m_data = data then
                exit do
            end if
            dim way : way = (node.m_data < data) and 1
            set node = node.m_child(way)
        loop
        set bstfindi = node
    end function

    public function bstputr(byval data)
        set m_root = bstputitemr(m_root, data)
        set bstputr = m_root
    end function

    private function bstputitemr(byval node, byval data)
        if node is nothing then
            set node = (new tbstnode).init(data)
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
        dim node, parent, way : set node = m_root : set parent = nothing
        do until node is nothing
            if node.m_data = data then
                set bstputi = node
                exit function
            end if
            set parent = node
            way = (node.m_data < data) and 1
            set node = node.m_child(way)
        loop
        set node = (new tbstnode).init(data)
        if parent is nothing then
            set m_root = node
        else
            set parent.m_child(way) = node
        end if
        set bstputi = node
    end function

    public function bstdeleter(byval data)
        set m_root = bstdeleteitemr(m_root, data)
        set bstdeleter = m_root
    end function

    private function bstdeleteitemr(byval node, byval data)
        if node is nothing then
            set bstdeleteitemr = node
        elseif node.m_data <> data then
            dim way : way = (node.m_data < data) and 1
            set node.m_child(way) = bstdeleteitemr(node.m_child(way), data)
            set bstdeleteitemr = node
        else ' found it
            if node.m_child(0) is nothing then  ' one child
                set bstdeleteitemr = node.m_child(1)
            elseif node.m_child(1) is nothing then  ' one child
                set bstdeleteitemr = node.m_child(0)
            else ' 2 children
                dim succ : set succ = node.m_child(1)
                do until succ.m_child(0) is nothing
                    set succ = succ.m_next(0)
                loop
                node.m_data = succ.m_data
                set node.m_child(1) = bstdeleteitemr(node.m_child(1), succ.m_data)
                set bstdeleteitemr = node
            end if
        end if
    end function

    public function bstdeletei(byval data)
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
            set bstdeletei = node
            exit function
        end if
        if parent is nothing then
            set m_root = q
        else
            set parent.m_child(way) = q
        end if
        set bstdeletei = node
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
