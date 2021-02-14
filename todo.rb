require "active_record"

class Todo < ActiveRecord::Base
  def due_today?
    due_date == Date.today
  end

  def to_displayable_string
    display_status = completed ? "[X]" : "[]"
    display_date = due_today? ? nil : due_date
    "#{id}. #{display_status} #{todo_text} #{display_date}"
  end

  def self.to_displayable_list
    all.map { |todo| todo.to_displayable_string }
  end

  def self.show_list
    overdue = where("completed = ? and due_date = ?", false, Date.today - 1).to_displayable_list
    due_today = where(due_date: Date.today).to_displayable_list.join("\n")
    due_later = where("due_date > ?", Date.today).to_displayable_list.join("\n")

    puts "Overdue\n#{overdue}\nDue Today\n#{due_today} \nDue Later\n#{due_later} \n"
  end

  def self.add_task(todo_hash)
    create!(todo_text: todo_hash[:todo_text], due_date: Date.today + todo_hash[:due_in_days], completed: false)
  end

  def self.mark_as_complete!(todo_id)
    todo = find_by(id: todo_id)
    if (todo != nil)
      todo.completed = true
      todo.save
    end
  end
end
