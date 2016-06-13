import os
import salt.exceptions


def initialized (name, user=None, group=None):
    '''
    Enforce the state of a custom thing

    This state module does a custom thing. It calls out to the execution module
    ``my_custom_module`` in order to check the current system and perform any
    needed changes.

    name
        The path to be initialized
    '''
    ret = {
        'name': name,
        'changes': {},
        'result': False,
        'comment': '',
        'pchanges': {},
        }

    # Start with basic error-checking. Do all the passed parameters make sense
    # and agree with each-other?
    if not os.path.exists(name):
        raise salt.exceptions.SaltInvocationError(
            '{0} must exist before it can be initialzied.'.format(name))

    # Check the current state of the system. Does anything need to change?
    try:
        __salt__['ipfs.show_config'](name, user=user, group=group)
    except:
        current_state = 'uninitialized'
    else:
        current_state = 'initialized'

    if current_state == 'initialized':
        ret['result'] = True
        ret['comment'] = 'System already in the correct state'
        return ret

    # The state of the system does need to be changed. Check if we're running
    # in ``test=true`` mode.
    if __opts__['test'] == True:
        ret['comment'] = 'The state of "{0}" will be changed.'.format(name)
        ret['pchanges'] = {
            'old': current_state,
            'new': 'initialized',
        }

        # Return ``None`` when running with ``test=true``.
        ret['result'] = None

        return ret

    # Finally, make the actual change and return the result.
    __salt__['ipfs.init'](name, user=user, group=group)

    ret['comment'] = 'The state of "{0}" was changed!'.format(name)

    ret['changes'] = {
        'old': current_state,
        'new': 'initialized',
    }

    ret['result'] = True

    return ret
