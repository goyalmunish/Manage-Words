import { moduleForModel, test } from 'ember-qunit';

moduleForModel('dictionary', 'Unit | Model | dictionary', {
  // Specify the other units that are required for this test.
  needs: ['model:user']
});

test('it exists', function(assert) {
  let model = this.subject();
  // let store = this.store();
  assert.ok(!!model);
});
