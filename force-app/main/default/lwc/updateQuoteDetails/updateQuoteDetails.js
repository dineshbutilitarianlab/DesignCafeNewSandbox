import { LightningElement, api} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'

export default class UpdateQuoteDetails extends LightningElement {
    _recordId;

    @api set recordId(value) {
        this._recordId = value;

        // do your thing right here with this.recordId / value
    }

    get recordId() {
        return this._recordId;
    }
    @api async invoke() {


        let event = new ShowToastEvent({
            title: 'I am a headless action!',
            message: 'Hi there! Starting...',
        });
        this.dispatchEvent(event);

        await this.sleep(2000);

        event = new ShowToastEvent({
            title: 'I am a headless action!',
            message: 'All done!',
        });
        this.dispatchEvent(event);
    }

    sleep(ms) {
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        return new Promise(resolve => setTimeout(resolve, ms));
    }
}