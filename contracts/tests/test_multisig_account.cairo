use array::ArrayTrait;
use contracts::ArgentMultisigAccount;
use debug::print_felt;
use traits::Into;

const signer_pubkey_1: felt = 0x759ca09377679ecd535a81e83039658bf40959283187c654c5416f439403cf5;
const signer_pubkey_2: felt = 0x1ef15c18599971b7beced415a40f0c7deacfd9b0d1819e03d723d8bc943cfca;


#[test]
#[available_gas(20000000)]
fn valid_initiliaze_one_signer() {
    let threshold = 1;
    let mut signers_array = ArrayTrait::new();
    signers_array.append(signer_pubkey_1);
    ArgentMultisigAccount::initialize(threshold, signers_array);

    assert(ArgentMultisigAccount::threshold::read() == threshold, 'new threshold not set');

    // test if signers is in list
    assert(ArgentMultisigAccount::signer_list::read(0) == signer_pubkey_1, 'signer 1 not added');

    // test if is signer correctly returns true
    assert(ArgentMultisigAccount::is_signer(signer_pubkey_1), 'is signer cant find signer');
}

#[test]
#[available_gas(20000000)]
fn valid_initiliaze_two_signers() {
    let threshold = 1;
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
}

#[test]
#[available_gas(20000000)]
#[should_panic(expected = 'argent/bad threshold')]
fn invalid_threshold() {
    let threshold = 3;
    let mut signers_array = ArrayTrait::new();
    signers_array.append(signer_pubkey_1);
    signers_array.append(signer_pubkey_2);
    ArgentMultisigAccount::initialize(threshold, signers_array);
}


#[test]
#[available_gas(20000000)]
#[should_panic(expected = 'argent/already-initialized')]
fn already_initialized() {
    let threshold = 1;
    let mut signers_array = ArrayTrait::new();
    signers_array.append(signer_pubkey_1);
    signers_array.append(signer_pubkey_2);
    ArgentMultisigAccount::initialize(threshold, signers_array);
    assert(ArgentMultisigAccount::threshold::read() == threshold, 'new threshold not set');

    let mut signers_array = ArrayTrait::new();
    signers_array.append(signer_pubkey_1);
    signers_array.append(signer_pubkey_2);
    ArgentMultisigAccount::initialize(threshold, signers_array);
}
