_osfamily               = fact('osfamily')
_operatingsystem        = fact('operatingsystem')
_operatingsystemrelease = fact('operatingsystemrelease').to_f

case _osfamily
when 'RedHat'
  if (_operatingsystem == 'Fedora' and _operatingsystemrelease >= 18) or (_operatingsystem != 'Fedora' and _operatingsystemrelease >= 7)
    $init_style = 'systemd'
  else
    $init_style = 'sysv'
  end
when 'Debian'
  if (_operatingsystem == 'Ubuntu' and _operatingsystemrelease >= 15.10) or (_operatingsystem == 'Debian' and _operatingsystemrelease >= 8.0)
    $init_style = 'systemd'
  elsif _operatingsystem == 'Ubuntu'
    $init_style = 'upstart'
  else
    $init_style = 'sysv'
  end
else
  $init_style = 'sysv'
end
