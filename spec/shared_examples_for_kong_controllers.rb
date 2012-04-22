shared_examples_for "a Kong controller" do
  context "the layout" do
    it "should render the kong layout" do
      response.should render_template('layouts/kong')
    end
  end
end

