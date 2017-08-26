option explicit

sub main()
    dim tree : set tree = new tbst
    set tree.m_root = (new tbstnode).init(5)
    set tree.m_root.m_child(0) = (new tbstnode).init(3)
    set tree.m_root.m_child(0).m_child(0) = (new tbstnode).init(1)
    set tree.m_root.m_child(0).m_child(0).m_child(1) = (new tbstnode).init(2)
    set tree.m_root.m_child(1) = (new tbstnode).init(7)
    tree.preorderr
    tree.preorderi
    tree.inorderr
    tree.inorderi
    tree.postorderr
    tree.postorderi
    tree.levelorderi
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
    if tree.bstfindr(4) is nothing then
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

    public function isbst(node)
        if node is nothing then
            isbst = true
        elseif isless(node, node.m_child(0)) or isless(node.m_child(1), node) then
            wscript.echo "ERROR: not a BST"
            isbst = false
        else
            isbst = true
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
        dim stack(25), scnt : scnt = 0
        dim node : set node = m_root
        do until node is nothing and scnt = 0
            if not node is nothing then
                wscript.stdout.write node.m_data & " "
                set stack(scnt) = node : scnt = scnt+1  ' push node
                set node = node.m_child(0)  ' left child
            else
                scnt = scnt-1 : set node = stack(scnt)  ' pop node
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
        dim stack(25), scnt : scnt = 0
        dim node : set node = m_root
        do until node is nothing and scnt = 0
            if not node is nothing then
                set stack(scnt) = node : scnt = scnt+1  ' push node
                set node = node.m_child(0)  ' left child
            else
                scnt = scnt-1 : set node = stack(scnt)  ' pop node
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
        dim stack(25), scnt : scnt = 0
        dim node, prev : set node = m_root : set prev = nothing
        do until node is nothing and scnt = 0
            if not node is nothing then
                set stack(scnt) = node : scnt = scnt+1  ' push node
                set node = node.m_child(0)  ' left child
            else
                scnt = scnt-1 : set node = stack(scnt)  ' pop node
                if node.m_child(1) is nothing or node.m_child(1) is prev then
                    wscript.stdout.write node.m_data & " "
                    set prev = node
                    set node = nothing
                else
                    set stack(scnt) = node : scnt = scnt+1  ' push node
                    set node = node.m_child(1)  ' right child
                end if
            end if
        loop
        wscript.stdout.writeline
    end sub

    public sub levelorderi()
        dim queue(25), qhead, qtail, qcnt : qhead = 0 : qtail = -1 : qcnt = 0
        if not m_root is nothing then
            qtail = (qtail+1) mod 25 : set queue(qtail) = m_root : qcnt = qcnt+1    ' enqueue root
        end if
        do until qcnt = 0
            dim node : set node = queue(qhead) : qhead = (qhead+1) mod 25 : qcnt = qcnt-1   ' dequeue
            wscript.stdout.write node.m_data & " "
            if not node.m_child(0) is nothing then
                qtail = (qtail+1) mod 25 : set queue(qtail) = node.m_child(0) : qcnt = qcnt+1    ' enqueue left child
            end if
            if not node.m_child(1) is nothing then
                qtail = (qtail+1) mod 25 : set queue(qtail) = node.m_child(1) : qcnt = qcnt+1    ' enqueue right child
            end if
        loop
        wscript.stdout.writeline
    end sub

end class

call main()
