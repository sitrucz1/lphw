'
' btree - a simple btree implementation
'

option explicit

sub main()
    includefile "queue.vbs"     ' tqueue and tstack
    dim btree : set btree = (new tbtree).init(2)

    ' btree.m_root.m_key(0) = 4
    ' btree.m_root.m_cnt = 1
    ' btree.m_root.m_leaf = false
    ' set btree.m_root.m_link(0) = (new tbtreenode).init(btree.m_degree)
    ' btree.m_root.m_link(0).m_key(0) = 2
    ' btree.m_root.m_link(0).m_cnt = 1
    ' btree.m_root.m_link(0).m_leaf = false
    ' set btree.m_root.m_link(1) = (new tbtreenode).init(btree.m_degree)
    ' btree.m_root.m_link(1).m_key(0) = 6
    ' btree.m_root.m_link(1).m_key(1) = 8
    ' btree.m_root.m_link(1).m_key(2) = 10
    ' btree.m_root.m_link(1).m_cnt = 3
    ' btree.m_root.m_link(1).m_leaf = false
    ' set btree.m_root.m_link(0).m_link(0) = (new tbtreenode).init(btree.m_degree)
    ' btree.m_root.m_link(0).m_link(0).m_key(0) = 1
    ' btree.m_root.m_link(0).m_link(0).m_cnt = 1
    ' set btree.m_root.m_link(0).m_link(1) = (new tbtreenode).init(btree.m_degree)
    ' btree.m_root.m_link(0).m_link(1).m_key(0) = 3
    ' btree.m_root.m_link(0).m_link(1).m_cnt = 1
    ' set btree.m_root.m_link(1).m_link(0) = (new tbtreenode).init(btree.m_degree)
    ' btree.m_root.m_link(1).m_link(0).m_key(0) = 5
    ' btree.m_root.m_link(1).m_link(0).m_cnt = 1
    ' set btree.m_root.m_link(1).m_link(1) = (new tbtreenode).init(btree.m_degree)
    ' btree.m_root.m_link(1).m_link(1).m_key(0) = 7
    ' btree.m_root.m_link(1).m_link(1).m_cnt = 1
    ' set btree.m_root.m_link(1).m_link(2) = (new tbtreenode).init(btree.m_degree)
    ' btree.m_root.m_link(1).m_link(2).m_key(0) = 9
    ' btree.m_root.m_link(1).m_link(2).m_cnt = 1
    ' set btree.m_root.m_link(1).m_link(3) = (new tbtreenode).init(btree.m_degree)
    ' btree.m_root.m_link(1).m_link(3).m_key(0) = 11
    ' btree.m_root.m_link(1).m_link(3).m_key(1) = 12
    ' btree.m_root.m_link(1).m_link(3).m_cnt = 2
    ' btree.print
    ' btree.isbtree
    ' wscript.quit

    '               |4|
    '             /    \
    '         |2|      |6   8   10|
    '         /\      /   |   |   \
    '       |1||3|   |5| |7| |9| |11 12|

    dim i
    ' randomize timer
    for i = 1 to 10
        btree.btput(i)
        ' btree.btput(int(rnd*100))
    next
    btree.traverse
    btree.print
    btree.isbtree

    ' btree.borrowright btree.m_root, 0
    ' btree.print
    ' btree.isbtree
    ' btree.borrowleft btree.m_root, 1
    ' btree.print
    ' btree.isbtree
    ' btree.joinnode btree.m_root.m_link(0), 1
    ' btree.print
    ' btree.isbtree
    ' btree.traverse
    ' wscript.quit

    btree.btdelete(6)
    btree.print
    btree.isbtree
    btree.btdelete(1)
    btree.print
    btree.isbtree
    btree.btdelete(8)
    btree.print
    btree.isbtree
    btree.btdelete(5)
    btree.print
    btree.isbtree
    btree.btdelete(2)
    btree.print
    btree.isbtree
    btree.btdelete(7)
    btree.print
    btree.isbtree
    btree.btdelete(4)
    btree.print
    btree.isbtree
    btree.btdelete(9)
    btree.print
    btree.isbtree
    btree.btdelete(3)
    btree.print
    btree.isbtree
    btree.btdelete(10)
    btree.print
    btree.isbtree

    ' do until btree.isempty or not btree.isbtree
    '     btree.btdelete(btree.m_root.m_key(0))
    '     btree.print
    ' loop

    btree.traverse

    ' if btree.btget(9) is nothing then
    '     wscript.echo "not found"
    ' else
    '     wscript.echo "found"
    ' end if
    ' if btree.btget(-1) is nothing then
    '     wscript.echo "not found"
    ' else
    '     wscript.echo "found"
    ' end if

    ' btree.splitnode btree.m_root, 1
    ' btree.traverse
    ' wscript.echo btree.m_root.m_cnt
end sub

sub includefile(fspec)
    executeglobal createobject("scripting.filesystemobject").opentextfile(fspec).readall()
end sub

class tbtreenode

    public m_key
    public m_link
    public m_leaf
    public m_cnt

    public function init(byval degree)
        redim m_key(2*degree-2)  ' 0..2*degree-2
        redim m_link(2*degree-1) ' 0..2*degree-1
        m_leaf = true
        m_cnt = 0
        set init = me
    end function

end class

class tbtree

    public m_root
    public m_degree

    public function init(byval degree)
        set m_root = (new tbtreenode).init(degree)
        m_degree = degree
        set init = me
    end function

    private function iif(byval condition, a, b)
        if condition then
            iif = a
        else
            iif = b
        end if
    end function

    public function isempty()
        isempty = (m_root.m_cnt = 0)
    end function

    public function isbtree()
        isbtree = (isbtreenode(m_root) <> -1)
    end function

    private function isbtreenode(byval node)
        if node is nothing then
            wscript.echo "Node is nothing.  Should NOT happen."
            isbtreenode = -1
        elseif node is m_root and (node.m_cnt < 0 or node.m_cnt > 2*m_degree-1) then
            isbtreenode = -1
            wscript.echo "Root node count is out of range."
        elseif not node is m_root and (node.m_cnt < m_degree-1 or node.m_cnt > 2*m_degree-1) then
            isbtreenode = -1
            wscript.echo "Non Root node count is out of range.", node.m_key(0), node.m_cnt
        elseif not inrange(node) then
            isbtreenode = -1
            wscript.echo "Node is not in range with children or keys aren't in ascending order."
        elseif node.m_leaf then
            isbtreenode = 1
        else
            dim i, height, balanced : redim height(node.m_cnt) : balanced = true
            for i = 0 to node.m_cnt
                height(i) = isbtreenode(node.m_link(i))
            next
            for i = 0 to node.m_cnt
                if height(i) = -1 then
                    balanced = false
                    exit for
                end if
                if i < node.m_cnt then
                    if height(i) <> height(i+1) then
                        balanced = false
                        exit for
                    end if
                end if
            next
            if not balanced then
                isbtreenode = -1
            else
                isbtreenode = 1+height(0)
            end if
        end if
    end function

    private function inrange(byval node)
        dim i, j, lc, rc
        for i = 0 to node.m_cnt-1
            if i < node.m_cnt-1 then
                if node.m_key(i+1) <= node.m_key(i) then
                    inrange = false
                    exit function
                end if
            end if
            if not node.m_leaf then
                set lc = node.m_link(i)
                for j = 0 to lc.m_cnt-1
                    if lc.m_key(j) >= node.m_key(i) then
                        inrange = false
                        exit function
                    end if
                next
                set rc = node.m_link(i+1)
                for j = 0 to rc.m_cnt-1
                    if rc.m_key(j) <= node.m_key(i) then
                        inrange = false
                    end if
                next
            end if
        next
        inrange = true
    end function

    private function nodematch(byval node, byval idx, byval data)
        if idx >= node.m_cnt then
            nodematch = false
        else
            nodematch = (node.m_key(idx) = data)
        end if
    end function

    public function btget(byval data)
        if m_root.m_cnt = 0 then
            set btget = nothing
        else
            set btget = btgetnode(m_root, data)
        end if
    end function

    private function btgetnode(byval node, byval data)
        dim i : i = 0
        do while i < node.m_cnt ' and data > node.m_key(i)
            if data <= node.m_key(i) then
                exit do
            end if
            i = i+1
        loop
        if nodematch(node, i, data) then
            set btgetnode = node
        elseif node.m_leaf then
            set btgetnode = nothing
        else
            set btgetnode = btgetnode(node.m_link(i), data)
        end if
    end function

    public function btput(byval data)
        wscript.echo "Inserting => ", data
        if m_root.m_cnt = 2*m_degree-1 then
            dim newroot : set newroot = (new tbtreenode).init(m_degree)
            set newroot.m_link(0) = m_root
            set m_root = newroot
            m_root.m_leaf = false
            m_root.m_cnt = 0
            splitnode m_root, 0
        end if
        set btput = btputnode(m_root, data)
    end function

    private function btputnode(byval node, byval data)
        dim i, j : i = 0
        do while i < node.m_cnt ' and data > node.m_key(i)
            if data <= node.m_key(i) then
                exit do
            end if
            i = i+1
        loop
        if nodematch(node, i, data) then
            set btputnode = node
        elseif node.m_leaf then ' do the insert
            for j = node.m_cnt-1 to i step -1
                node.m_key(j+1) = node.m_key(j)
            next
            node.m_key(i) = data
            node.m_cnt = node.m_cnt+1
            set btputnode = node
        else ' keep searching
            if node.m_link(i).m_cnt < 2*m_degree-1 then
                set btputnode = btputnode(node.m_link(i), data)
            else
                splitnode node, i
                ' since median of child came up to node we need to check if there's a match or i changes
                if node.m_key(i) = data then
                    set btputnode = node
                else
                    i = iif(data > node.m_key(i), i+1, i)
                    set btputnode = btputnode(node.m_link(i), data)
                end if
            end if
        end if
    end function

    public sub splitnode(byref node, byval idx)
        dim i, child, sib
        set child = node.m_link(idx)
        set sib = (new tbtreenode).init(m_degree)
        wscript.echo "splitting..."
        ' Move nodes over in parent
        for i = node.m_cnt-1 to idx step -1
            node.m_key(i+1) = node.m_key(i)
        next
        ' Copy median of child to parent
        node.m_key(idx) = child.m_key(m_degree-1)
        ' Copy right split data to new sibling
        for i = 0 to m_degree-2
            sib.m_key(i) = child.m_key(i+m_degree)
        next
        ' Update leafs
        sib.m_leaf = child.m_leaf
        ' Move links over in parent
        for i = node.m_cnt to idx+1 step -1
            set node.m_link(i+1) = node.m_link(i)
        next
        ' Point to new node
        set node.m_link(idx+1) = sib
        ' Update sibling links
        if not sib.m_leaf then
            for i = 0 to m_degree-1
                set sib.m_link(i) = child.m_link(i+m_degree)
            next
        end if
        ' Update counts
        node.m_cnt = node.m_cnt+1
        child.m_cnt = m_degree-1
        sib.m_cnt = m_degree-1
    end sub

    public function btdelete(byval data)
        wscript.echo "Deleting => ", data
        set btdelete = btdeletenode(m_root, data)
        if m_root.m_cnt = 0 and not m_root.m_leaf then
            wscript.echo "updating root...", m_root.m_link(0).m_key(0)
            set m_root = m_root.m_link(0)
        end if
    end function

    private function btdeletenode(byref node, byval data)
        wscript.echo "entering delete => ", node.m_key(0)
        dim i, j : i = 0
        do while i < node.m_cnt ' and data > node.m_key(i)
            if data <= node.m_key(i) then
                exit do
            end if
            i = i+1
        loop
        if nodematch(node, i, data) then  ' found the node delete it
            wscript.echo "found node...", node.m_key(i), i
            if node.m_leaf then
                wscript.echo "leaf node...", node.m_key(i), i
                for j = i+1 to node.m_cnt-1
                    node.m_key(j-1) = node.m_key(j)
                next
                node.m_cnt = node.m_cnt-1
                wscript.echo "deleted!"
                set btdeletenode = node
            elseif node.m_link(i).m_cnt >= m_degree then
                node.m_key(i) = predecessor(node, i)
                set btdeletenode = btdeletenode(node.m_link(i), node.m_key(i))
            elseif node.m_link(i+1).m_cnt >= m_degree then
                node.m_key(i) = successor(node, i)
                set btdeletenode = btdeletenode(node.m_link(i+1), node.m_key(i))
            else
                joinnode node, i
                set btdeletenode = btdeletenode(node.m_link(i), data)
            end if
        elseif node.m_leaf then ' not found
            set btdeletenode = nothing
        else ' keep searching
            wscript.echo "keep searching, not in current node...", node.m_key(iif(i = node.m_cnt, i-1, i)), i
            if node.m_link(i).m_cnt >= m_degree then
                set btdeletenode = btdeletenode(node.m_link(i), data)
            elseif canborrowleft(node, i) then ' dont have short-circuit boolean logic so had to write function
                borrowleft node, i
                set btdeletenode = btdeletenode(node.m_link(i), data)
            elseif canborrowright(node, i) then
                borrowright node, i
                set btdeletenode = btdeletenode(node.m_link(i), data)
            else
                i = iif(i = node.m_cnt, i-1, i)
                joinnode node, i
                set btdeletenode = btdeletenode(node.m_link(i), data)
            end if
        end if
    end function

    private function predecessor(byval node, byval idx)
        wscript.echo "getting predecessor..."
        dim x : set x = node.m_link(idx)
        do until x.m_leaf
            set x = x.m_link(x.m_cnt)
        loop
        predecessor = x.m_key(x.m_cnt-1)
        wscript.echo "predecessor is ", x.m_key(x.m_cnt-1)
    end function

    private function successor(byval node, byval idx)
        wscript.echo "getting successor..."
        dim x : set x = node.m_link(idx+1)
        do until x.m_leaf
            set x = x.m_link(0)
        loop
        successor = x.m_key(0)
        wscript.echo "successor is ", x.m_key(0)
    end function

    private function canborrowleft(byval node, byval idx)
        if idx = 0 then
            canborrowleft = false
        else
            canborrowleft = (node.m_link(idx-1).m_cnt >= m_degree)
        end if
    end function

    private function canborrowright(byval node, byval idx)
        if idx = node.m_cnt then
            canborrowright = false
        else
            canborrowright = (node.m_link(idx+1).m_cnt >= m_degree)
        end if
    end function

    public sub borrowleft(byref node, byval idx)
        wscript.echo "borrow left..."
        dim i, child, sib
        set child = node.m_link(idx)
        set sib = node.m_link(idx-1)
        for i = child.m_cnt-1 to 0 step -1
            child.m_key(i+1) = child.m_key(i)
        next
        child.m_key(0) = node.m_key(idx-1)
        node.m_key(idx-1) = sib.m_key(sib.m_cnt-1)
        if not child.m_leaf then
            for i = child.m_cnt to 0 step -1
                set child.m_link(i+1) = child.m_link(i)
            next
            set child.m_link(0) = sib.m_link(sib.m_cnt)
        end if
        child.m_cnt = child.m_cnt+1
        sib.m_cnt = sib.m_cnt-1
    end sub

    public sub borrowright(byref node, byval idx)
        wscript.echo "borrow right..."
        dim i, child, sib
        set child = node.m_link(idx)
        set sib = node.m_link(idx+1)
        child.m_key(child.m_cnt) = node.m_key(idx)
        node.m_key(idx) = sib.m_key(0)
        for i = 1 to sib.m_cnt-1
            sib.m_key(i-1) = sib.m_key(i)
        next
        if not child.m_leaf then
            set child.m_link(child.m_cnt+1) = sib.m_link(0)
            for i = 1 to sib.m_cnt
                set sib.m_link(i-1) = sib.m_link(i)
            next
        end if
        child.m_cnt = child.m_cnt+1
        sib.m_cnt = sib.m_cnt-1
    end sub

    public sub joinnode(byref node, byval idx)
        wscript.echo "joining nodes...", node.m_key(idx), idx
        dim i, child, sib
        set child = node.m_link(idx)
        set sib = node.m_link(idx+1)
        ' move median to child
        child.m_key(m_degree-1) = node.m_key(idx)
        ' move sib keys to child
        for i = 0 to sib.m_cnt-1
            child.m_key(i+m_degree) = sib.m_key(i)
        next
        ' fill the gap in node due to median moving
        for i = idx to node.m_cnt-2
            node.m_key(i) = node.m_key(i+1)
        next
        ' update links
        if not child.m_leaf then
            for i = 0 to sib.m_cnt
                set child.m_link(i+m_degree) = sib.m_link(i)
            next
        end if
        set node.m_link(idx) = child ' already points to child but nice for readability
        for i = idx+1 to node.m_cnt-1
            set node.m_link(i) = node.m_link(i+1)
        next
        ' update counts
        child.m_cnt = 2*m_degree-1
        node.m_cnt = node.m_cnt-1
        ' garbage collection frees nodes once nothing points to it
    end sub

    public sub traverse()
        if m_root.m_cnt > 0 then
            traversenode m_root
        end if
        wscript.stdout.writeline
    end sub

    private sub traversenode(byval node)
        dim i
        for i = 0 to node.m_cnt-1
            if not node.m_leaf then
                traversenode node.m_link(i)
            end if
            wscript.stdout.write node.m_key(i) & " "
        next
        if not node.m_leaf then
            traversenode node.m_link(node.m_cnt)
        end if
    end sub

    public sub print
        if m_root is nothing then
            exit sub
        end if
        if m_root.m_cnt = 0 then
            exit sub
        end if
        dim level, queue : level = 1 : set queue = new tqueue
        queue.enqueue m_root
        do until queue.isempty
            dim i, node : set node = queue.dequeue
            wscript.stdout.write "|"
            for i = 0 to node.m_cnt-2
                wscript.stdout.write node.m_key(i) & " "
            next
            wscript.stdout.write node.m_key(node.m_cnt-1) & "| "
            if not node.m_leaf then
                for i = 0 to node.m_cnt
                    queue.enqueue node.m_link(i)
                next
            end if
            level = level-1
            if level = 0 then
                level = queue.length
                wscript.stdout.writeline
            end if
        loop
        wscript.stdout.writeline
    end sub

end class

call main
