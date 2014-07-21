require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe FlagsController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # Flag. As you add validations to Flag, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { {"name" => "MyString"} }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # FlagsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all flags as @flags" do
      flag = Flag.create! valid_attributes
      get :index, {}, valid_session
      assigns(:flags).should eq([flag])
    end
  end

  describe "GET show" do
    it "assigns the requested flag as @flag" do
      flag = Flag.create! valid_attributes
      get :show, {:id => flag.to_param}, valid_session
      assigns(:flag).should eq(flag)
    end
  end

  describe "GET new" do
    it "assigns a new flag as @flag" do
      get :new, {}, valid_session
      assigns(:flag).should be_a_new(Flag)
    end
  end

  describe "GET edit" do
    it "assigns the requested flag as @flag" do
      flag = Flag.create! valid_attributes
      get :edit, {:id => flag.to_param}, valid_session
      assigns(:flag).should eq(flag)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Flag" do
        expect {
          post :create, {:flag => valid_attributes}, valid_session
        }.to change(Flag, :count).by(1)
      end

      it "assigns a newly created flag as @flag" do
        post :create, {:flag => valid_attributes}, valid_session
        assigns(:flag).should be_a(Flag)
        assigns(:flag).should be_persisted
      end

      it "redirects to the created flag" do
        post :create, {:flag => valid_attributes}, valid_session
        response.should redirect_to(Flag.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved flag as @flag" do
        # Trigger the behavior that occurs when invalid params are submitted
        Flag.any_instance.stub(:save).and_return(false)
        post :create, {:flag => {"name" => "invalid value"}}, valid_session
        assigns(:flag).should be_a_new(Flag)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Flag.any_instance.stub(:save).and_return(false)
        post :create, {:flag => {"name" => "invalid value"}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested flag" do
        flag = Flag.create! valid_attributes
        # Assuming there are no other flags in the database, this
        # specifies that the Flag created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Flag.any_instance.should_receive(:update).with({"name" => "MyString"})
        put :update, {:id => flag.to_param, :flag => {"name" => "MyString"}}, valid_session
      end

      it "assigns the requested flag as @flag" do
        flag = Flag.create! valid_attributes
        put :update, {:id => flag.to_param, :flag => valid_attributes}, valid_session
        assigns(:flag).should eq(flag)
      end

      it "redirects to the flag" do
        flag = Flag.create! valid_attributes
        put :update, {:id => flag.to_param, :flag => valid_attributes}, valid_session
        response.should redirect_to(flag)
      end
    end

    describe "with invalid params" do
      it "assigns the flag as @flag" do
        flag = Flag.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Flag.any_instance.stub(:save).and_return(false)
        put :update, {:id => flag.to_param, :flag => {"name" => "invalid value"}}, valid_session
        assigns(:flag).should eq(flag)
      end

      it "re-renders the 'edit' template" do
        flag = Flag.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Flag.any_instance.stub(:save).and_return(false)
        put :update, {:id => flag.to_param, :flag => {"name" => "invalid value"}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested flag" do
      flag = Flag.create! valid_attributes
      expect {
        delete :destroy, {:id => flag.to_param}, valid_session
      }.to change(Flag, :count).by(-1)
    end

    it "redirects to the flags list" do
      flag = Flag.create! valid_attributes
      delete :destroy, {:id => flag.to_param}, valid_session
      response.should redirect_to(flags_url)
    end
  end

end
