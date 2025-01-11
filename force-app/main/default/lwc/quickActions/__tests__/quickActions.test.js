import { createElement } from 'lwc/engine';
import QuickActions from 'c/quickActions';

describe('c-quick-actions', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('should render the component', () => {
        // Arrange
        const element = createElement('c-quick-actions', {
            is: QuickActions
        });

        // Act
        document.body.appendChild(element);

        // Assert
        expect(element).toBeTruthy();
    });

    it('should display the correct title', () => {
        // Arrange
        const element = createElement('c-quick-actions', {
            is: QuickActions
        });

        // Act
        document.body.appendChild(element);

        // Assert
        const titleElement = element.shadowRoot.querySelector('h1');
        expect(titleElement.textContent).toBe('Quick Actions');
    });

    it('should handle button click', () => {
        // Arrange
        const element = createElement('c-quick-actions', {
            is: QuickActions
        });
        document.body.appendChild(element);

        // Mock the handleClick method
        const handleClickMock = jest.fn();
        element.handleClick = handleClickMock;

        // Act
        const button = element.shadowRoot.querySelector('button');
        button.click();

        // Assert
        expect(handleClickMock).toHaveBeenCalled();
    });

    it('should display the correct message after button click', async () => {
        // Arrange
        const element = createElement('c-quick-actions', {
            is: QuickActions
        });
        document.body.appendChild(element);

        // Act
        const button = element.shadowRoot.querySelector('button');
        button.click();

        // Wait for any asynchronous DOM updates
        await Promise.resolve();

        // Assert
        const messageElement = element.shadowRoot.querySelector('.message');
        expect(messageElement.textContent).toBe('Action completed!');
    });
});