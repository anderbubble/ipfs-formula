{% set ipfs_repository_dir = '/srv/ipfs' %}

/var/local/ipfs/:
  file:
    - directory
    - user: root
    - group: root
    - mode: 0755

/opt/ipfs:
  archive:
    - extracted
    - archive_format: tar
    - source: {{ pillar['ipfs']['source'] }}
    - source_hash: {{ pillar['ipfs']['source_hash'] }}

/usr/local/bin/ipfs:
  file:
    - managed
    - source: salt://ipfs/files/ipfs.sh
    - user: root
    - group: root
    - mode: 0755

{{ ipfs_repository_dir }}:
  file:
    - directory
    - user: ipfs
    - group: ipfs
    - mode: 0755

  ipfs_repository:
    - initialized
    - user: ipfs
    - group: ipfs
    - require:
      - file: /srv/ipfs
      - file: /usr/local/bin/ipfs

ipfs:
  user:
    - present
    - shell: /bin/nologin
    - home: /srv/ipfs
    - groups:
      - ipfs

  group:
    - present
    - members:
      - ipfs
    - require:
      - user: ipfs

  service:
    - running
    - enable: True
    - watch:
        - file: /etc/systemd/system/ipfs.service
        - file: /etc/sysconfig/ipfs

/etc/systemd/system/ipfs.service:
  file:
    - managed
    - source: salt://ipfs/files/ipfs.service
    - user: root
    - group: root
    - mode: 0644

/etc/sysconfig/ipfs:
  file:
    - managed
    - source: salt://ipfs/files/sysconfig
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - context:
        ipfs_repository_dir: {{ ipfs_repository_dir }}
