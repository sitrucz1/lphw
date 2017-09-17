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

    '               |4|
    '             /    \
    '         |2|      |6   8   10|
    '         /\      /   |   |   \
    '       |1||3|   |5| |7| |9| |11 12|

    dim i
    randomize timer
    for i = 1 to 10
        btree.btput(i)
        ' btree.btput(int(rnd*100))
    next
    btree.print
    btree.borrowright btree.m_root, 0
    btree.print
    btree.borrowleft btree.m_root, 1
    btree.print
    wscript.quit
    btree.joinnode btree.m_root.m_link(0), 0
    btree.print
    btree.traverse
    wscript.quit

    btree.btdelete(1)
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

    private function nodematch(byval node, byval index, byval data)
        if index >= node.m_cnt then
            nodematch = false
        else
            nodematch = (node.m_key(index) = data)
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
        do while i < node.m_cnt
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
        dim i : i = 0
        do while i < node.m_cnt
            if data <= node.m_key(i) then
                exit do
            end if
            i = i+1
        loop
        if nodematch(node, i, data) then
            set btputnode = node
        elseif node.m_leaf then ' do the insert
            dim j
            for j = node.m_cnt-1 to i step -1
                node.m_key(j+1) = node.m_key(j)
            next
            node.m_key(i) = data
            node.m_cnt = node.m_cnt+1
            set btputnode = node
        else ' keep searching
            if node.m_link(i).m_cnt = 2*m_degree-1 then
                splitnode node, i
                ' since median of child came up to node we need to check if there's a match or i changes
                if node.m_key(i) = data then
                    set btputnode = node
                else
                    i = iif(data > node.m_key(i), i+1, i)
                    set btputnode = btputnode(node.m_link(i), data)
                end if
            else
                set btputnode = btputnode(node.m_link(i), data)
            end if
        end if
    end function

    public sub splitnode(byref node, byval idx)
        dim i, xnode, ynode
        set xnode = node.m_link(idx)
        set ynode = (new tbtreenode).init(m_degree)
        wscript.echo "splitting..."
        ' Move nodes over in parent
        for i = node.m_cnt-1 to idx step -1
            node.m_key(i+1) = node.m_key(i)
        next
        ' Copy median of child to parent
        node.m_key(idx) = xnode.m_key(m_degree-1)
        ' Copy right split data to new node
        for i = 0 to m_degree-2
            ynode.m_key(i) = xnode.m_key(i+m_degree)
        next
        ' Update leafs
        ynode.m_leaf = xnode.m_leaf
        ' Move links over in parent
        for i = node.m_cnt to idx+1 step -1
            set node.m_link(i+1) = node.m_link(i)
        next
        ' Point to new node
        set node.m_link(idx+1) = ynode
        ' Update ynode links
        if not ynode.m_leaf then
            for i = 0 to m_degree-1
                set ynode.m_link(i) = xnode.m_link(i+m_degree)
            next
        end if
        ' Update counts
        node.m_cnt = node.m_cnt+1
        xnode.m_cnt = m_degree-1
        ynode.m_cnt = m_degree-1
    end sub

    public function btdelete(byval data)
        set btdelete = btdeletenode(m_root, data)
    end function

    private function btdeletenode(byref node, byval data)
        dim i, j : i = 0
        do while i < node.m_cnt
            if data <= node.m_key(i) then
                exit do
            end if
            i = i+1
        loop
        if nodematch(node, i, data) then  ' found the node delete it
            if node.m_leaf then
                for j = i+1 to node.m_cnt-1
                    node.m_key(j-1) = node.m_key(j)
                next
                node.m_cnt = node.m_cnt-1
                set btdeletenode = node
            elseif node.m_link(i).m_cnt >= m_degree then
                node.m_key(i) = predecessor(node.m_link(i))
                set btdeletenode = btdeletenode(node.m_link(i), node.m_key(i))
            elseif node.m_link(i+1).m_cnt >= m_degree then
                node.m_key(i) = successor(node.m_link(i+1))
                set btdeletenode = btdeletenode(node.m_link(i+1), node.m_key(i))
            else
                joinnode node, i
                set btdeletenode = btdeletenode(node.m_link(i), data)
            end if
        elseif node.m_leaf then ' not found
            set btdeletenode = nothing
        else ' keep searching
            wscript.echo "keep searching..."
            if node.m_link(i).m_cnt < m_degree then
                if canborrowleft(node, i) then ' dont have short-circuit boolean logic so had to write function
                    borrowleft node, i
                elseif canborrowright(node, i) then
                    borrowright node, i
                else
                    joinnode node, iif(i = node.m_cnt, i-1, i)
                end if
            end if
            set btdeletenode = btdeletenode(node.m_link(i), data)
        end if
    end function

    private function predecessor(byval node)
        wscript.echo "getting predecessor..."
        dim x : set x = node
        do until x.m_leaf
            set x = x.m_link(x.m_cnt)
        loop
        predecessor = x.m_key(x.m_cnt-1)
    end function

    private function successor(byval node)
        wscript.echo "getting successor..."
        dim x : set x = node
        do until x.m_leaf
            set x = x.m_link(0)
        loop
        successor = x.m_key(0)
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
        dim i, idxnode, sibnode
        set idxnode = node.m_link(idx)
        set sibnode = node.m_link(idx-1)
        for i = idxnode.m_cnt-1 to 0 step -1
            idxnode.m_key(i+1) = idxnode.m_key(i)
        next
        idxnode.m_key(0) = node.m_key(iif(idx = node.m_cnt, idx-1, idx))
        node.m_key(iif(idx = node.m_cnt, idx-1, idx)) = sibnode.m_key(sibnode.m_cnt-1)
        if not idxnode.m_leaf then
            for i = idxnode.m_cnt to 0 step -1
                set idxnode.m_link(i+1) = idxnode.m_link(i)
            next
            set idxnode.m_link(0) = sibnode.m_link(sibnode.m_cnt)
        end if
        idxnode.m_cnt = idxnode.m_cnt+1
        sibnode.m_cnt = sibnode.m_cnt-1
    end sub

    public sub borrowright(byref node, byval idx)
        wscript.echo "borrow right..."
        dim i, idxnode, sibnode
        set idxnode = node.m_link(idx)
        set sibnode = node.m_link(idx+1)
        idxnode.m_key(idxnode.m_cnt) = node.m_key(idx)
        node.m_key(idx) = sibnode.m_key(0)
        for i = 1 to sibnode.m_cnt-1
            sibnode.m_key(i-1) = sibnode.m_key(i)
        next
        if not idxnode.m_leaf then
            set idxnode.m_link(idxnode.m_cnt+1) = sibnode.m_link(0)
            for i = 1 to sibnode.m_cnt
                set sibnode.m_link(i-1) = sibnode.m_link(i)
            next
        end if
        idxnode.m_cnt = idxnode.m_cnt+1
        sibnode.m_cnt = sibnode.m_cnt-1
    end sub

    public sub joinnode(byref node, byval idx)
        wscript.echo "joining nodes...", idx
        dim i, idxnode, sibnode
        set idxnode = node.m_link(idx)
        set sibnode = node.m_link(idx+1)
        ' move median to child
        idxnode.m_key(m_degree-1) = node.m_key(idx)
        ' move sib keys to child
        for i = 0 to sibnode.m_cnt-1
            idxnode.m_key(i+m_degree) = sibnode.m_key(i)
        next
        ' fill the gap in node due to median moving
        for i = idx to node.m_cnt-2
            node.m_key(i) = node.m_key(i+1)
        next
        ' update links
        if not idxnode.m_leaf then
            for i = 0 to sibnode.m_cnt
                set idxnode.m_link(i+m_degree) = sibnode.m_link(i)
            next
        end if
        set node.m_link(idx) = idxnode ' do I need this?
        for i = idx+1 to node.m_cnt
            set node.m_link(i) = node.m_link(i+1)
        next
        ' update counts
        idxnode.m_cnt = 2*m_degree-1
        node.m_cnt = node.m_cnt-1
        ' update root if it is empty
        if node is m_root and node.m_cnt = 0 then
            set m_root = idxnode
        end if
        set sibnode = nothing
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
