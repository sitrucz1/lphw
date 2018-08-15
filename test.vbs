option explicit

sub main
    dim t, t1, t2
    set t = (new tt).init(5)
    set t1 = (new tt).init(1)
    set t2 = (new tt).init(2)
    call subtest(t, t1, t2)
    wscript.echo t.m_root.m_data
    wscript.echo t1.m_root.m_data
    wscript.echo t2.m_root.m_data
    wscript.echo typename(t)
    wscript.echo vartype(t)
    set t = nothing
    wscript.echo t1.m_root.m_data
    wscript.echo t2.m_root.m_data
    wscript.echo typename(t)
    wscript.echo vartype(t)
    wscript.echo log(14), log(2), log(14) / log(2), int(log(14) / log(2)), cint(log(14) / log(2))
end sub

sub subtest(byval a, byref b, byref c)
    set b.m_root = a.m_root
    set c.m_root = a.m_root
end sub

class tt

    public m_root

    public function init(byval data)
        set m_root = (new uu).init(data)
        set init = me
    end function

end class

class uu

    public m_data

    public function init(byval data)
        m_data = data
        set init = me
    end function

end class

call main
