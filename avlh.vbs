'
' AVL Tree using height
'
option explicit

sub main()
    includefile "queue.vbs"     ' tqueue and tstack
    dim tree : set tree = new tavl
    dim i : i = 0
    randomize timer
    do
        i = i+1
        dim j : j = int(rnd*100)
        tree.avlputr(j)
        ' tree.print
    loop until i > 10 or not tree.isavl
    tree.print
    wscript.echo "Press ENTER to continue..."
    wscript.stdin.read(1)
    do
        tree.avldeleter(tree.m_root.m_data)
        tree.print
    loop until tree.isempty or not tree.isavl
end sub

sub includefile(fspec)
    executeglobal createobject("scripting.filesystemobject").opentextfile(fspec).readall()
end sub

class tavlnode

    public m_data
    public m_height
    public m_child(1)

    public function init(byval data)
        m_data = data
        m_height = 1
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

    private function iif(condition, a, b)
        if condition then
            iif = a
        else
            iif = b
        end if
    end function

    public function isempty()
        isempty = (m_root is nothing)
    end function

    private function getnodeheight(byval node)
        if node is nothing then
            getnodeheight = 0
        else
            getnodeheight = node.m_height
        end if
    end function

    private function getbal(byval node)
        if node is nothing then
            getbal = 0
        else
            getbal = getnodeheight(node.m_child(1)) - getnodeheight(node.m_child(0))
        end if
    end function

    private sub setnodeheight(byref node)
        if not node is nothing then
            dim lh : lh = getnodeheight(node.m_child(0))
            dim rh : rh = getnodeheight(node.m_child(1))
            node.m_height = 1+max(lh, rh)
        end if
    end sub

    public function isavl()
        isavl = (isavlnode(m_root) <> -1)
    end function

    private function isavlnode(byval node)
        if node is nothing then
            isavlnode = 0
        elseif isless(node, node.m_child(0)) or isless(node.m_child(1), node) then
            wscript.echo "ERROR: not a BST", node.m_data, node.m_height
            isavlnode = -1
        else
            dim lh : lh = isavlnode(node.m_child(0))
            dim rh : rh = isavlnode(node.m_child(1))
            dim diff : diff = rh-lh
            if lh = -1 or rh = -1 then
                isavlnode = -1  ' an error above already trapped this dont echo
            elseif diff < -1 or diff > 1 then
                wscript.echo "ERROR: left and right subtrees differ by more than 1", node.m_data, node.m_height
                isavlnode = -1
            elseif node.m_height <> 1+max(lh, rh) then
                wscript.echo "ERROR: node balance doesn't match heights", node.m_data, node.m_height
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
        setnodeheight node
        setnodeheight root
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

    public function avlputr(byval data)
        wscript.echo "Inserting => ", data
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
            ' rebalance
            setnodeheight node
            dim bal : bal = getbal(node)
            if bal = -2 or bal = 2 then
                ' rotate
                dim way2 : way2 = (node.m_child(way).m_data < data) and 1
                if way <> way2 then
                    wscript.echo "**rotate", node.m_child(way).m_data, way
                    set node.m_child(way) = rotate(node.m_child(way), way)
                end if
                wscript.echo "*rotate", node.m_child(way).m_data, way xor 1
                set node = rotate (node, way xor 1)
            end if
            set avlputitemr = node
        end if
    end function

    public function avldeleter(byval data)
        wscript.echo "Deleting => ", data
        set m_root = avldeleteitemr(m_root, data)
        set avldeleter = m_root
    end function

    private function avldeleteitemr(byval node, byval data)
        if node is nothing then
            set avldeleteitemr = node
        elseif node.m_data <> data then
            dim way : way = (node.m_data < data) and 1
            set node.m_child(way) = avldeleteitemr(node.m_child(way), data)
            set node = deleteitembal(node, way)
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
                set node.m_child(way) = avldeleteitemr(node.m_child(way), succ.m_data)
                set node = deleteitembal(node, way)
                set avldeleteitemr = node
            end if
        end if
    end function

    private function deleteitembal(byval node, byval way)
        setnodeheight node
        dim bal : bal = getbal(node)
        if bal = -2 or bal = 2 then
            dim w : set w = node.m_child(way xor 1) ' sibling
            dim nbal : nbal = iif(bal = -2, -1, 1)
            dim wbal : wbal = getbal(w)
            if nbal = -wbal then
                wscript.echo "**rotate", node.m_child(way xor 1).m_data, way xor 1
                set node.m_child(way xor 1) = rotate(node.m_child(way xor 1), way xor 1)
            end if
            wscript.echo "*rotate", node.m_data, way
            set node = rotate(node, way)
        end if
        set deleteitembal = node
    end function

    public sub print()
        dim queue : set queue = new tqueue
        if m_root is nothing then
            exit sub
        end if
        queue.enqueue m_root
        dim lcnt : lcnt = queue.length  ' set number of nodes at current level
        do until queue.isempty
            dim node : set node = queue.dequeue
            wscript.stdout.write node.m_data & "," & node.m_height & " "
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
