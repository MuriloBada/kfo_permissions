create table kfo_permissions(
    id integer primary key not null auto_increment,
    idplayer int not null,
    permission varchar(50) not null,
    perm_lv int not null
);
ALTER TABLE users ADD banned INT DEFAULT 0 NOT NULL;
ALTER TABLE users ADD ds_ban VARCHAR(300);