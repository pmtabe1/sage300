class CreateViewTriggers < ActiveRecord::Migration[5.1]
  def change
    execute <<-SQL
      drop view if exists Triggers
    SQL

    execute <<-SQL
      CREATE VIEW Triggers AS
      SELECT
        sys.sysobjects.id, sys.sysobjects.name AS trigger_name,
        USER_NAME(sys.sysobjects.uid) AS trigger_owner, s.name AS table_schema,
        OBJECT_NAME(sys.sysobjects.parent_obj) AS table_name, 
        OBJECTPROPERTY(sys.sysobjects.id, 'ExecIsUpdateTrigger') AS isupdate,
        OBJECTPROPERTY(sys.sysobjects.id, 'ExecIsDeleteTrigger') AS isdelete,
        OBJECTPROPERTY(sys.sysobjects.id, 'ExecIsInsertTrigger') AS isinsert,
        OBJECTPROPERTY(sys.sysobjects.id, 'ExecIsAfterTrigger') AS isafter,
        OBJECTPROPERTY(sys.sysobjects.id, 'ExecIsInsteadOfTrigger') AS isinsteadof,
        OBJECTPROPERTY(sys.sysobjects.id, 'ExecIsTriggerDisabled') AS disabled,
        OBJECT_DEFINITION(sys.sysobjects.id) AS trigger_definition
      FROM sys.sysobjects
      INNER JOIN sys.sysusers ON sys.sysobjects.uid = sys.sysusers.uid
      INNER JOIN sys.tables AS t ON sys.sysobjects.parent_obj = t.object_id
      INNER JOIN sys.schemas AS s ON t.schema_id = s.schema_id
      WHERE (sys.sysobjects.type = 'TR')
    SQL
  end
end
