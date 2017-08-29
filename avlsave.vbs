'
' AVL Tree
'

option explicit

sub main()
    dim arr : arr = array(5, 2, 4, 10, 12, -5, 16, 17, 1, 8, 14, 19, 13, 11, 6, 9, 3, 7)
    dim avltree : set avltree = new tavltree
    dim i : i = 0
    randomize timer
    do
        avltree.put((new tavlitem).init(int(rnd*100)))
        ' avltree.print
        ' wscript.stdin.read(1)
        ' wscript.stdout.writeline
        i = i+1
    loop until i > 75 or not avltree.isavl()
    avltree.print
    for i = 1 to treeheight(avltree.m_root)
        breadthprint avltree.m_root, i
    next
    wscript.stdout.writeline
    ibreadthprint avltree.m_root
    wscript.stdout.writeline
    do
        ' avltree.print
        set avltree.m_root = avltree.delete(avltree.m_root)
    loop until not avltree.isavl() or avltree.m_root is nothing
    avltree.print
end sub

sub breadthprint(byval node, byval level)
    if not node is nothing then
        if level = 1 then
            wscript.stdout.write node.m_item & " "
        elseif level > 1 then
            breadthprint node.m_left, level-1
            breadthprint node.m_right, level-1
        end if
    end if
end sub

sub ibreadthprint(byval node)
    dim queue(25), qhead, qtail, qcnt : qhead = 0 : qtail = -1 : qcnt = 0
    qtail = (qtail+1) mod 25 : set queue(qtail) = node : qcnt = qcnt+1     ' enqueue
    do until qcnt = 0 or node is nothing
        set node = queue(qhead) : qhead = (qhead+1) mod 25 : qcnt = qcnt-1  ' dequeue
        wscript.stdout.write node.m_item & " "
        if not node.m_left is nothing then
            qtail = (qtail+1) mod 25 : set queue(qtail) = node.m_left : qcnt = qcnt+1     ' enqueue
        end if
        if not node.m_right is nothing then
            qtail = (qtail+1) mod 25 : set queue(qtail) = node.m_right : qcnt = qcnt+1     ' enqueue
        end if
    loop
    wscript.stdout.writeline
end sub

function treeheight(node)
    if node is nothing then
        treeheight = 0
    else
        dim lh : lh = treeheight(node.m_left)
        dim rh : rh = treeheight(node.m_right)
        if lh > rh then
            treeheight = 1 + lh
        else
            treeheight = 1 + rh
        end if
    end if
end function

class tavlitem

    public m_item
    public m_bal
    public m_left
    public m_right

    public function init(item)
        if vartype(item) = vbobject then
            set m_item = item
        else
            m_item = item
        end if
        m_bal = 0
        set m_left = nothing
        set m_right = nothing
        set init = me
    end function

end class

class tavltree

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
            isless = (a.m_item < b.m_item)
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
        elseif isless(node, node.m_left) or isless(node.m_right, node) then
            wscript.echo "ERROR: not a BST"
            isavlnode = -1
        elseif node.m_bal < -1 or node.m_bal > 1 then
            wscript.echo "ERROR: node balance is out of range"
            isavlnode = -1
        else
            dim lh : lh = isavlnode(node.m_left)
            dim rh : rh = isavlnode(node.m_right)
            if lh = -1 or rh = -1 then
                isavlnode = -1  ' an error above already trapped this dont echo
            elseif node.m_bal <> (rh - lh) then
                wscript.echo "ERROR: node balance doesn't match heights", node.m_item, node.m_bal
                isavlnode = -1
            else
                isavlnode = 1 + max(lh, rh)
            end if
        end if
    end function

    public function put(byval item)
        dim done : done = false
        wscript.echo "Put ", item.m_item
        set m_root = putitem(m_root, item, done)
    end function

    private function putitem(byval node, byval item, byref done)
        if node is nothing then
            set putitem = item
        elseif item.m_item = node.m_item then
            done = true
            set putitem = node
        elseif item.m_item < node.m_item then
            set node.m_left = putitem(node.m_left, item, done)
            if not done then
                node.m_bal = node.m_bal-1
                if node.m_bal = 0 then
                    done = true
                elseif node.m_bal = -2 then
                    wscript.echo "Rebalance at " & node.m_item
                    if item.m_item > node.m_left.m_item then
                        set node.m_left = rotateleft(node.m_left)
                        set node = rotateright(node)
                        adjustbal node
                    else
                        set node = rotateright(node)
                        node.m_bal = 0
                        node.m_right.m_bal = 0
                    end if
                    done = true
                end if
            end if
            set putitem = node
        else
            set node.m_right = putitem(node.m_right, item, done)
            if not done then
                node.m_bal = node.m_bal+1
                if node.m_bal = 0 then
                    done = true
                elseif node.m_bal = 2 then
                    wscript.echo "Rebalance at " & node.m_item
                    if item.m_item < node.m_right.m_item then
                        set node.m_right = rotateright(node.m_right)
                        set node = rotateleft(node)
                        adjustbal node
                    else
                        set node = rotateleft(node)
                        node.m_bal = 0
                        node.m_left.m_bal = 0
                    end if
                    done = true
                end if
            end if
            set putitem = node
        end if
    end function

    public function delete(byval item)
        dim done : done = false
        wscript.echo "Delete " & item.m_item
        set m_root = deletenode(m_root, item, done)
        set delete = m_root
    end function

    private function deletenode(byval node, byval item, byref done)
        if node is nothing then
            set deletenode = node
        elseif item.m_item < node.m_item then
            set node.m_left = deletenode(node.m_left, item, done)
            set node = balance(node, true, done)
            set deletenode = node
        elseif item.m_item > node.m_item then
            set node.m_right = deletenode(node.m_right, item, done)
            set node = balance(node, false, done)
            set deletenode = node
        else ' node.m_item = item.m_item
            if node.m_left is nothing then
                set deletenode = node.m_right
            elseif node.m_right is nothing then
                set deletenode = node.m_left
            else ' two children
                dim succ : set succ = node.m_right
                do until succ.m_left is nothing
                    set succ = succ.m_left
                loop
                node.m_item = succ.m_item
                set node.m_right = deletenode(node.m_right, succ, done)
                set node = balance(node, false, done)
                set deletenode = node
            end if
        end if
    end function

    private function balance(byval node, byval isleft, byref done)
        if done then
            set balance = node
            exit function
        end if
        dim child, gchild
        if isleft then
            node.m_bal = node.m_bal+1
            if node.m_bal = 1 then
                done = true
            elseif node.m_bal = 2 then
                set child = node.m_right
                if child.m_bal > -1 then
                    set gchild = child.m_right
                else
                    set gchild = child.m_left
                end if
                ' rotate
                wscript.echo "Rebalance at " & node.m_item
                if child.m_left is gchild then
                    set node.m_right = rotateright(node.m_right)
                    set node = rotateleft(node)
                    adjustbal node
                else
                    set node = rotateleft(node)
                    if node.m_bal = 0 then
                        node.m_bal = -1
                        node.m_left.m_bal = 1
                        done = true ' b/c node balance <> 0
                    else
                        node.m_bal = 0
                        node.m_left.m_bal = 0
                    end if
                end if
            end if
        else
            node.m_bal = node.m_bal-1
            if node.m_bal = -1 then
                done = true
            elseif node.m_bal = -2 then
                set child = node.m_left
                if child.m_bal < 1 then
                    set gchild = child.m_left
                else
                    set gchild = child.m_right
                end if
                ' rotate
                wscript.echo "Rebalance at " & node.m_item
                if child.m_right is gchild then
                    set node.m_left = rotateleft(node.m_left)
                    set node = rotateright(node)
                    adjustbal node
                else
                    set node = rotateright(node)
                    if node.m_bal = 0 then
                        node.m_bal = 1
                        node.m_right.m_bal = -1
                        done = true ' b/c node balance <> 0
                    else
                        node.m_bal = 0
                        node.m_right.m_bal = 0
                    end if
                end if
            end if
        end if
        set balance = node
    end function

    private function rotateleft(byval node)
        dim temp
        set temp = node.m_right
        set node.m_right = temp.m_left
        set temp.m_left = node
        set rotateleft = temp
    end function

    private function rotateright(byval node)
        dim temp
        set temp = node.m_left
        set node.m_left = temp.m_right
        set temp.m_right = node
        set rotateright = temp
    end function

    private sub adjustbal(byref node)
        ' node.m_bal is prior to the double rotation that
        ' moves node up to the root (ie node).  once we double rotate
        ' we need to update the balances but node could have
        ' had 3 conditions 0, 1, -1.  I drew it out on paper
        ' so these numbers may seem confusing without a copy of my notes.
        if node.m_bal = 0 then
            node.m_left.m_bal = 0
            node.m_right.m_bal = 0
        elseif node.m_bal = 1 then
            node.m_left.m_bal = -1
            node.m_right.m_bal = 0
        else ' node.m_bal = -1
            node.m_left.m_bal = 0
            node.m_right.m_bal = 1
        end if
        node.m_bal = 0
    end sub

    public sub print()
        printitem m_root
    end sub

    private sub printitem(byval node)
        if node is nothing then
            ' wscript.stdout.write "*,0 "
        else
            wscript.stdout.writeline formatnode(node)
            printitem(node.m_left)
            printitem(node.m_right)
        end if
    end sub

    private function formatnode(byval node)
        if node is nothing then
            formatnode = ""
        else
            if node.m_left is nothing then
                formatnode = "*,0 "
            else
                formatnode = node.m_left.m_item & "," & node.m_left.m_bal & " "
            end if
            formatnode = formatnode & node.m_item & "," & node.m_bal & " "
            if node.m_right is nothing then
                formatnode = formatnode & "*,0 "
            else
                formatnode = formatnode & node.m_right.m_item & "," & node.m_right.m_bal & " "
            end if
        end if
    end function

end class

call main()
