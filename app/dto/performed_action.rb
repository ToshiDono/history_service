class Dto
  class PerformedAction
    attr_reader :actor_id, :actor_type, :subject_id, :subject_type, :action, :created_at

    def initialize(performed_action)
      @actor_id = performed_action[:actor_id]
      @actor_type = performed_action[:actor_type]
      @subject_id = performed_action['subject_id']
      @subject_type = performed_action['subject_type']
      @action = performed_action['action']
      @created_at = performed_action['created_at']
    end
  end
end