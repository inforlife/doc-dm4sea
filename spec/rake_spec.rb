RSpec.describe 'datamatrix:send' do
  load "Rakefile"
  let(:task)    { Rake::Task[self.class.top_level_description] }
  # task.execute to run the task
  # task.prerequisites to access the tasks that task depends on
  # task.invoke to run the task and its prerequisite tasks

  it 'delegates the job to EmailDataMatrix' do
    email_data_matrix_class = class_spy('EmailDataMatrix').as_stubbed_const

    task.execute(batch_code: 'LOT1')

    expect(email_data_matrix_class).to have_received(:for_batch).with('LOT1')
  end
end
