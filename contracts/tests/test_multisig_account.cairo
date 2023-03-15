use array::ArrayTrait;
use contracts::ArgentMultisigAccount;
use traits::Into;

const signer_pubkey_1: felt252 = 0x759ca09377679ecd535a81e83039658bf40959283187c654c5416f439403cf5;
const signer_pubkey_2: felt252 = 0x1ef15c18599971b7beced415a40f0c7deacfd9b0d1819e03d723d8bc943cfca;
const signer_pubkey_3: felt252 = 0x411494b501a98abd8262b0da1351e17899a0c4ef23dd2f96fec5ba847310b20;

#[test]
#[available_gas(20000000)]
fn valid_before_init() {
    assert(ArgentMultisigAccount::get_signers().is_empty(), 'invalid signers length');
}


#[test]
#[available_gas(20000000)]
fn valid_initiliaze() {
    let threshold = 1_u32;
    let mut signers_array = ArrayTrait::new();
    signers_array.append(signer_pubkey_1);
    ArgentMultisigAccount::initialize(threshold, signers_array);

    assert(ArgentMultisigAccount::threshold::read() == threshold, 'new threshold not set');

    // test if signers is in list
    assert(ArgentMultisigAccount::signer_list::read(0) == signer_pubkey_1, 'signer 1 not added');

    // test if is signer correctly returns true
    assert(ArgentMultisigAccount::is_signer(signer_pubkey_1), 'is signer cant find signer');

    // test signers list
    let signers = ArgentMultisigAccount::get_signers();
    assert(signers.len() == 1_usize, 'invalid signers length');
    assert(*signers.at(0_usize) == signer_pubkey_1, 'invalid signers result');
}

#[test]
#[available_gas(20000000)]
fn valid_initiliaze_two_signers() {
    let threshold = 1_u32;
    let mut signers_array = ArrayTrait::new();
    signers_array.append(signer_pubkey_1);
    signers_array.append(signer_pubkey_2);
    ArgentMultisigAccount::initialize(threshold, signers_array);

    assert(ArgentMultisigAccount::threshold::read() == threshold, 'new threshold not set');

    // test if signers is in list
    assert(ArgentMultisigAccount::signer_list::read(0) == signer_pubkey_1, 'signer 1 not added');
    assert(
        ArgentMultisigAccount::signer_list::read(signer_pubkey_1) == signer_pubkey_2,
        'signer 2 not added'
    );

    // test if is signer correctly returns true
    assert(ArgentMultisigAccount::is_signer(signer_pubkey_1), 'is signer cant find signer 1');
    assert(ArgentMultisigAccount::is_signer(signer_pubkey_2), 'is signer cant find signer 2');

    // test signers list
    let signers = ArgentMultisigAccount::get_signers();
    assert(signers.len() == 2_usize, 'invalid signers length');
    assert(*signers.at(0_usize) == signer_pubkey_1, 'invalid signers result');
    assert(*signers.at(1_usize) == signer_pubkey_2, 'invalid signers result');
}

#[test]
#[available_gas(20000000)]
#[should_panic(expected = ('argent/bad-threshold', ))]
fn invalid_threshold() {
    let threshold = 3_u32;
    let mut signers_array = ArrayTrait::new();
    signers_array.append(signer_pubkey_1);
    signers_array.append(signer_pubkey_2);
    ArgentMultisigAccount::initialize(threshold, signers_array);
}

#[test]
#[available_gas(20000000)]
fn change_threshold() {
    let threshold = 1_u32;
    let mut signers_array = ArrayTrait::new();
    signers_array.append(1);
    signers_array.append(2);
    ArgentMultisigAccount::initialize(threshold, signers_array);
    assert(ArgentMultisigAccount::get_threshold() == threshold, 'new threshold not set');

    ArgentMultisigAccount::change_threshold(2_u32);
    assert(ArgentMultisigAccount::get_threshold() == 2_u32, 'new threshold not set');
}


#[test]
#[available_gas(20000000)]
fn add_signers() {
    // init
    let threshold = 1_u32;
    let mut signers_array = ArrayTrait::new();
    signers_array.append(signer_pubkey_1);
    ArgentMultisigAccount::initialize(threshold, signers_array);

    // add signer
    let mut new_signers = ArrayTrait::new();
    new_signers.append(signer_pubkey_2);
    ArgentMultisigAccount::add_signers(2_u32, new_signers);

    // check 
    let signers = ArgentMultisigAccount::get_signers();
    assert(signers.len() == 2_usize, 'invalid signers length');
    assert(ArgentMultisigAccount::get_threshold() == 2_u32, 'new threshold not set');
}


#[test]
#[available_gas(20000000)]
#[should_panic(expected = ('argent/already-a-signer', ))]
fn add_signer_already_in_list() {
    // init
    let threshold = 1_u32;
    let mut signers_array = ArrayTrait::new();
    signers_array.append(signer_pubkey_1);
    ArgentMultisigAccount::initialize(threshold, signers_array);

    // add signer
    let mut new_signers = ArrayTrait::new();
    new_signers.append(signer_pubkey_1);
    ArgentMultisigAccount::add_signers(2_u32, new_signers);
}


#[test]
#[available_gas(20000000)]
fn get_name_and_version() {
    assert(
        ArgentMultisigAccount::get_name() == ArgentMultisigAccount::NAME, 'not getting correct name'
    );
    assert(
        ArgentMultisigAccount::get_version() == ArgentMultisigAccount::VERSION,
        'not getting correct name'
    );
}
